defmodule PresencyWeb.Admin.DashboardController do
  use PresencyWeb, :controller

  def show(conn, _params) do
    admin = conn.assigns.current_admin
    token = Phoenix.Token.sign(conn, "socket_login", admin.id)
    conn
    |> render("show.html", token: token)
  end

end