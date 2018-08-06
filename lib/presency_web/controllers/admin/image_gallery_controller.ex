defmodule PresencyWeb.Admin.ImageGalleryController do
  use PresencyWeb, :controller

  alias Presency.CMS

  def index(conn, _params) do
    render(conn, "index.html")
  end

end
