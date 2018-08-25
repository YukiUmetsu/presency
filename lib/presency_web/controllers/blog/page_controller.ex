defmodule PresencyWeb.Blog.PageController do
  use PresencyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
