defmodule GetLoan.ApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GetLoan.Applications` context.
  """

  @doc """
  Generate a application.
  """
  def application_fixture(attrs \\ %{}) do
    {:ok, application} =
      attrs
      |> Enum.into(%{
        additional_income: true,
        email: "email@example.com",
        expenses_per_month: 42,
        income_per_month: 42,
        own_car: true,
        own_home: true,
        paying_job_12month: true,
        paying_job_now: true,
        stage: :risks
      })
      |> GetLoan.Applications.create_application()

    application
  end
end
