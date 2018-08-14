defmodule PresencyWeb.Admin.ImageGalleryController do
  use PresencyWeb, :controller

  alias Presency.CMS
  import PhoenixGon.Controller

  def index(conn, params) do
    page = CMS.list_paginated_images(params["page"], 8)
    admin = conn.assigns.current_admin
    token = Phoenix.Token.sign(conn, "image_api_login", admin.id)
    conn = put_gon(conn, token: token)
    render conn, "index.html",
           images: page.entries,
           token: token,
           page: page
  end

end
