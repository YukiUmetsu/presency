defmodule PresencyWeb.Admin.UserController do
  use PresencyWeb, :controller
  alias Presency.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    conn
    |> render("index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

end
