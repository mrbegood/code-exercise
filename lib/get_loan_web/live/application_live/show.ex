defmodule GetLoanWeb.ApplicationLive.Show do
  use GetLoanWeb, :live_view

  alias GetLoan.Applications

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mx-auto max-w-2xl space-y-10 text-lg">
        <.list>
          <:item title="Do you have a paying job?">{answer(@application.paying_job_now) }</:item>
          <:item title="Did you consistently had a paying job for past 12 months?">{answer(@application.paying_job_12month) }</:item>
          <:item title="Do you own a home?">{answer(@application.own_home) }</:item>
          <:item title="Do you own a car?">{answer(@application.own_car) }</:item>
          <:item title="Do you have any additional source of income?">{answer(@application.additional_income) }</:item>
          <:item title="What is yout total monthly income from all income source (in USD)?">{@application.income_per_month }</:item>
          <:item title="What is your total monthly expenses (in USD)?">{@application.expenses_per_month }</:item>
        </.list>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Application")
     |> assign(:application, Applications.get_application!(id))}
  end

  defp answer(true), do: "yes"
  defp answer(_), do: "no"
end
