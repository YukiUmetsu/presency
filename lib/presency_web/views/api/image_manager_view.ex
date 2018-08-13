defmodule PresencyWeb.Api.ImageManagerView do
  use PresencyWeb, :view
  alias Helpers.Dates
  require IEx

  def render("index.json", %{images_data: images_data}) do
    images = images_data.images
    %{
      images: render_many(images, PresencyWeb.Api.ImageManagerView, "image.json"),
      page_number: images_data.page_number,
      page_size: images_data.page_size,
      total_pages: images_data.total_pages,
      total_entries: images_data.total_entries
    }
  end

  def render("index.json", %{error: error}) do
    %{error: error}
  end

  def render("new.json", %{response: response}) do
    response
  end

  def render("image.json", %{image_manager: image}) do
    %{
      id: image.id,
      path: String.trim_leading(image.path, "priv/static"),
      tag: image.tag,
      updated: Dates.to_date_time_str(image.updated_at, true)
    }
  end
end
