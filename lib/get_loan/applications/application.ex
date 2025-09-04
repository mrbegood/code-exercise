defmodule GetLoan.Applications.Application do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "applications" do
    field :email, :string
    field :paying_job_now, :boolean, default: false
    field :paying_job_12month, :boolean, default: false
    field :own_home, :boolean, default: false
    field :own_car, :boolean, default: false
    field :additional_income, :boolean, default: false
    field :income_per_month, :integer, default: 0
    field :expenses_per_month, :integer, default: 0
    field :stage, Ecto.Enum, values: [:risks, :balance, :contacts, :rejected, :approved], default: :risks

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:email, :paying_job_now, :paying_job_12month, :own_home, :own_car, :additional_income, :income_per_month, :expenses_per_month, :stage])
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/, message: "is invalid")
  end
end
