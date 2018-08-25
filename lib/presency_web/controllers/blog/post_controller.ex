defmodule PresencyWeb.Blog.PostController do
  use PresencyWeb, :controller
  require IEx

  def show(conn, %{"post_url_id" => post_url_id}) do
    render conn, "show.html", post_url_id: post_url_id
  end
end
