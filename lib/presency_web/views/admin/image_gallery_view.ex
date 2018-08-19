defmodule PresencyWeb.Admin.ImageGalleryView do
  use PresencyWeb, :view
  import Scrivener.HTML

  def get_path(image) do
    String.trim_leading(image.path, "priv/static")
  end

  def get_alt(image) do
    case Blankable.blank?(Map.fetch(image, "caption")) do
      true -> "Image #{image.id}"
      false -> image.caption
    end
  end
end
