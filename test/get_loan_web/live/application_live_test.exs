defmodule GetLoanWeb.ApplicationLiveTest do
  use GetLoanWeb.ConnCase

  import Phoenix.LiveViewTest
  import GetLoan.ApplicationsFixtures

  alias GetLoan.Applications

  defp create_application(_) do
    application = application_fixture(%{
      paying_job_now: false,
      paying_job_12month: false,
      own_home: false,
      own_car: false,
      additional_income: false,
      expenses_per_month: 0,
      income_per_month: 0,
      email: nil,
    })

    %{application: application}
  end

  describe "New" do
    test "Creates new Application", %{conn: conn} do
      assert Applications.list_applications() == []

      {:error, {:live_redirect, _}} = live(conn, ~p"/applications/new")

      assert Applications.list_applications() |> length() == 1
    end

    test "Redirects to Edit form", %{conn: conn} do
      {:error, {:live_redirect, %{to: edit_application_path }}} = live(conn, ~p"/applications/new")
      application = Applications.list_applications() |> List.last()

      assert edit_application_path == "/applications/#{application.id}/edit"
    end
  end

  describe "Edit form" do
    setup [:create_application]

    test "Shows Risks Assessment form when stage is :risks", %{conn: conn} do
      {:ok, application} = Applications.create_application(%{stage: :risks})

      {:ok, _edit_live, html} = live(conn, ~p"/applications/#{application}/edit")

      assert html =~ "Do you have a paying job?"
      assert html =~ "Did you consistently had a paying job for past 12 months?"
      assert html =~ "Do you own a home?"
      assert html =~ "Do you own a car?"
      assert html =~ "Do you have any additional source of income?"
    end

    test "Shows Rejected page when Risk Assessment didn't pass", %{conn: conn} do
      params = %{
        paying_job_now: false,
        paying_job_12month: false,
        own_home: false,
        own_car: false,
        additional_income: false,
      }

      {:ok, application} = Applications.create_application(%{stage: :risks})
      {:ok, view, _html} = live(conn, ~p"/applications/#{application}/edit")

      result = view |> element("#application-form") |> render_submit(application: params)
      assert result =~ "We are currently unable to issue credit to you."
    end

    test "Shows Balance form when Risk Assessment passed", %{conn: conn} do
      params = %{
        paying_job_now: true,
        paying_job_12month: true,
        own_home: true,
        own_car: true,
        additional_income: true,
      }

      {:ok, application} = Applications.create_application(%{stage: :risks})
      {:ok, view, _html} = live(conn, ~p"/applications/#{application}/edit")

      result = view |> element("#application-form") |> render_submit(application: params)
      assert result =~ "What is yout total monthly income from all income source (in USD)?"
    end

    test "Shows Balance form when stage is :balance", %{conn: conn} do
      {:ok, application} = Applications.create_application(%{stage: :balance})
      {:ok, _edit_live, html} = live(conn, ~p"/applications/#{application}/edit")

      assert html =~ "What is yout total monthly income from all income source (in USD)?"
      assert html =~ "What is your total monthly expenses (in USD)?"
    end

    test "Shows Rejected page when negative balance specified", %{conn: conn} do
      params = %{
        income_per_month: 100,
        expenses_per_month: 200,
      }

      {:ok, application} = Applications.create_application(%{stage: :balance})
      {:ok, view, _html} = live(conn, ~p"/applications/#{application}/edit")

      result = view |> element("#application-form") |> render_submit(application: params)
      assert result =~ "We are currently unable to issue credit to you."
    end

    test "Shows Contacts form when positive balance specified", %{conn: conn} do
      params = %{
        income_per_month: 200,
        expenses_per_month: 100,
      }

      {:ok, application} = Applications.create_application(%{stage: :balance})
      {:ok, view, _html} = live(conn, ~p"/applications/#{application}/edit")

      result = view |> element("#application-form") |> render_submit(application: params)
      assert result =~ "Congratulations!"
    end

    test "Shows Contacts form when stage is :contacts", %{conn: conn} do
      {:ok, application} = Applications.create_application(%{
        stage: :contacts,
        income_per_month: 1000,
        expenses_per_month: 900,
      })

      {:ok, _edit_live, html} = live(conn, ~p"/applications/#{application}/edit")

      assert html =~ "Congratulations!"
      assert html =~ "You have been approved for credit up to 1200 amount (in USD)"
    end

    test "Shows Rejected page when stage is :rejected", %{conn: conn} do
      {:ok, application} = Applications.create_application(%{stage: :rejected})
      {:ok, _edit_live, html} = live(conn, ~p"/applications/#{application}/edit")

      assert html =~ "Thank you for your answer."
      assert html =~ "We are currently unable to issue credit to you."
    end

    test "Shows Approved page when stage is :approved", %{conn: conn} do
      {:ok, application} = Applications.create_application(%{stage: :approved})
      {:ok, _edit_live, html} = live(conn, ~p"/applications/#{application}/edit")

      assert html =~ "Thank you for your request."
      assert html =~ "Check your email for credit details."
    end
  end

  describe "Show" do
    setup [:create_application]

    test "displays application preview for pdf generation", %{conn: conn, application: application} do
      {:ok, _show_live, html} = live(conn, ~p"/applications/#{application}")

      assert html =~ "Do you have a paying job?"
      assert html =~ "Did you consistently had a paying job for past 12 months?"
      assert html =~ "Do you own a home?"
      assert html =~ "Do you own a car?"
      assert html =~ "Do you have any additional source of income?"
      assert html =~ "What is yout total monthly income from all income source (in USD)?"
      assert html =~ "What is your total monthly expenses (in USD)?"
    end
  end
end
