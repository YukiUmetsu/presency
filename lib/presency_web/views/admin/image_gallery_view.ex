defmodule PresencyWeb.Admin.ImageGalleryView do
  use PresencyWeb, :view
  import Scrivener.HTML

  def get_path(image) do
    String.trim_leading(image.path, "priv/static")
  end

end
