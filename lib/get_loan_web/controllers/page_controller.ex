defmodule GetLoanWeb.PageController do
  use GetLoanWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
