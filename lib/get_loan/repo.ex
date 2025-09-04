defmodule GetLoan.Repo do
  use Ecto.Repo,
    otp_app: :get_loan,
    adapter: Ecto.Adapters.SQLite3
end
