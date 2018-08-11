defmodule PresencyWeb.Admin.ImageGalleryView do
  use PresencyWeb, :view

  def get_path(image) do
    String.trim_leading(image.path, "priv/static")
  end
end
