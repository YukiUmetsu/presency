defmodule PresencyWeb.Plugs.AdminLayout do
  import Phoenix.Controller, only: [put_layout: 2]

  def init(_opts), do: nil

  def call(conn, _opts) do
    conn
    |> put_layout({PresencyWeb.LayoutView, "admin_app.html"})
  end
end
