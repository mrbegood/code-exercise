defmodule GetLoan.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :paying_job_now, :boolean, default: false, null: false
      add :paying_job_12month, :boolean, default: false, null: false
      add :own_home, :boolean, default: false, null: false
      add :own_car, :boolean, default: false, null: false
      add :additional_income, :boolean, default: false, null: false
      add :income_per_month, :integer, default: 0
      add :expenses_per_month, :integer, default: 0
      add :stage, :string, default: "risks"

      timestamps(type: :utc_datetime)
    end
  end
end
