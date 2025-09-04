defmodule GetLoan.ApplicationsTest do
  use GetLoan.DataCase

  alias GetLoan.Applications

  describe "applications" do
    alias GetLoan.Applications.Application

    import GetLoan.ApplicationsFixtures

    @invalid_attrs %{email: "invalid"}

    test "list_applications/0 returns all applications" do
      application = application_fixture()
      assert Applications.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert Applications.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      valid_attrs = %{email: "email@example.com", paying_job_now: true, paying_job_12month: true, own_home: true, own_car: true, additional_income: true, income_per_month: 42, expenses_per_month: 42, stage: :risks}

      assert {:ok, %Application{} = application} = Applications.create_application(valid_attrs)
      assert application.email == "email@example.com"
      assert application.paying_job_now == true
      assert application.paying_job_12month == true
      assert application.own_home == true
      assert application.own_car == true
      assert application.additional_income == true
      assert application.income_per_month == 42
      assert application.expenses_per_month == 42
      assert application.stage == :risks
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_application(@invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      application = application_fixture()
      update_attrs = %{email: "updated-email@example.com", paying_job_now: false, paying_job_12month: false, own_home: false, own_car: false, additional_income: false, income_per_month: 43, expenses_per_month: 43, stage: :balance}

      assert {:ok, %Application{} = application} = Applications.update_application(application, update_attrs)
      assert application.email == "updated-email@example.com"
      assert application.paying_job_now == false
      assert application.paying_job_12month == false
      assert application.own_home == false
      assert application.own_car == false
      assert application.additional_income == false
      assert application.income_per_month == 43
      assert application.expenses_per_month == 43
      assert application.stage == :balance
    end

    test "update_application/2 with invalid data returns error changeset" do
      application = application_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_application(application, @invalid_attrs)
      assert application == Applications.get_application!(application.id)
    end

    test "delete_application/1 deletes the application" do
      application = application_fixture()
      assert {:ok, %Application{}} = Applications.delete_application(application)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end
    end

    test "change_application/1 returns a application changeset" do
      application = application_fixture()
      assert %Ecto.Changeset{} = Applications.change_application(application)
    end
  end
end
