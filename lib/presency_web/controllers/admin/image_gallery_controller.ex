defmodule PresencyWeb.Admin.ImageGalleryController do
  use PresencyWeb, :controller

  alias Presency.CMS

  def index(conn, _params) do
    images = CMS.list_image()
    render(conn, "index.html", images: images)
  end

end
