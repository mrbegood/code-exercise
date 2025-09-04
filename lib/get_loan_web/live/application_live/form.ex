defmodule GetLoanWeb.ApplicationLive.Form do
  use GetLoanWeb, :live_view

  alias GetLoan.Applications
  alias GetLoan.Applications.RiskAssessment

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div :if={@form.data.stage == :risks} class="mx-auto max-w-xl space-y-10 text-lg">
        <h1 class="text-xl text-center">Please answer following questions:</h1>

        <.form for={@form} id="application-form" phx-submit="save">
          <.input field={@form[:paying_job_now]} type="checkbox" label="Do you have a paying job?" />
          <.input field={@form[:paying_job_12month]} type="checkbox" label="Did you consistently had a paying job for past 12 months?" />
          <.input field={@form[:own_home]} type="checkbox" label="Do you own a home?" />
          <.input field={@form[:own_car]} type="checkbox" label="Do you own a car?" />
          <.input field={@form[:additional_income]} type="checkbox" label="Do you have any additional source of income?" />
          <footer class="text-center py-6">
            <.button phx-disable-with="Processing..." variant="primary">Continue</.button>
          </footer>
        </.form>
      </div>

      <div :if={@form.data.stage == :balance} class="mx-auto max-w-xl space-y-4 text-lg">
        <h1 class="text-xl text-center">Please answer following questions:</h1>

        <.form for={@form} id="application-form" phx-submit="save">
          <.input field={@form[:income_per_month]} type="number" min="0" label="What is yout total monthly income from all income source (in USD)?" />
          <.input field={@form[:expenses_per_month]} type="number" min="0" label="What is your total monthly expenses (in USD)?" />
          <footer class="text-center">
            <.button phx-disable-with="Processing..." variant="primary">Continue</.button>
          </footer>
        </.form>
      </div>

      <div :if={@form.data.stage == :contacts} class="mx-auto max-w-xl space-y-4 text-lg">
        <h1 class="text-xl text-center">Congratulations!<br> You have been approved for credit up to <%= approved_amount(@form.data) %> amount (in USD)</h1>
        <.form for={@form} id="application-form" phx-submit="save">
          <.input field={@form[:email]} type="email" required="true"  label="Email" />
          <footer class="text-center">
            <.button phx-disable-with="Processing..." variant="primary">Request an offer</.button>
          </footer>
        </.form>
      </div>

      <div :if={@form.data.stage == :rejected} class="mx-auto max-w-xl space-y-10 text-lg text-center">
        <h1 class="text-xl">
          Thank you for your answer.<br> We are currently unable to issue credit to you.
        </h1>
        <.link href={~p"/"} class="btn btn-primary btn-xl">Back to main page</.link>
      </div>

      <div :if={@form.data.stage == :approved} class="mx-auto max-w-xl space-y-10 text-lg text-center">
        <h1 class="text-xl">
          Thank you for your request.<br> Check your email for credit details.
        </h1>

        <%= if Mix.env() == :dev do %>
          <p>Visit development <a href="/dev/mailbox" class="text-blue-500 underline" target="_blank">mailbox</a></p>
        <% end %>

        <.link href={~p"/"} class="btn btn-primary btn-xl">Back to main page</.link>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    application = Applications.get_application!(id)

    socket
    |> assign(:application, application)
    |> assign(:form, to_form(Applications.change_application(application)))
  end

  defp apply_action(socket, :new, _params) do
    {:ok, application} = Applications.create_application(%{})

    socket |> push_navigate(to: return_path("edit", application))
  end

  @impl true
  def handle_event("save", %{"application" => application_params}, socket) do
    save_application(socket, socket.assigns.live_action, application_params)
  end

  defp save_application(socket, :edit, application_params) do
    # calculate additional stage params based on user input
    application_params = put_next_stage(socket.assigns.application.stage, application_params)

    case Applications.update_application(socket.assigns.application, application_params) do
      {:ok, application} ->
        if socket.assigns.application.stage == :contacts do
           send_email(application)
        end

        {:noreply,
          socket
          |> assign(:application, application)
          |> assign(:form, to_form(Applications.change_application(application)))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp put_next_stage(:risks, params) do
    case RiskAssessment.passed(params) do
      true  -> Map.put(params, "stage", :balance)
      false -> Map.put(params, "stage", :rejected)
    end
  end

  defp put_next_stage(:balance, params) do
    income = Integer.parse(params["income_per_month"])
    expenses = Integer.parse(params["expenses_per_month"])

    case income > expenses do
      true  -> Map.put(params, "stage", :contacts)
      false -> Map.put(params, "stage", :rejected)
    end
  end

  defp put_next_stage(:contacts, params) do
    Map.put(params, "stage", :approved)
  end

  defp put_next_stage(_, params), do: params

  defp approved_amount(application) do
    (application.income_per_month - application.expenses_per_month) * 12
  end

  def send_email(_application) do
    # todo: run async tasks to generate PDF and send Mail
  end

  defp return_path("edit", application), do: ~p"/applications/#{application}/edit"
end
