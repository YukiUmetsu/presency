defmodule PresencyWeb.Admin.PostView do
  use PresencyWeb, :view
  import Helpers.Dates, only: [to_date_time_str: 1]
  import Helpers.Posts, only: [show_category_title: 2, show_title_in_one_line: 1]
  import Helpers.Quill, only: [delta_to_html: 1, posts_content_to_html_array: 0]
  import Scrivener.HTML
  require IEx

  def post_content_to_html() do
    delta_to_html("post_content")
  end

  def posts_content_to_array() do
    posts_content_to_html_array()
    |> String.replace("\\", "")
  end

  def show_category_title_in_view(category_id, categories \\ []) do
    show_category_title(category_id, categories)
  end

  def to_date_time_string(date) do
    to_date_time_str(date)
  end

  def show_tags(tags \\ []) do
    show_title_in_one_line(tags)
  end

  def get_path(image) do
    String.trim_leading(image.path, "priv/static")
  end

  def show_image(image) do
    src = image |> get_path
    "<img src='#{src}' width='200px'>" |> raw()
  end

  def show_post_image_id(post) do
    case post.image do
      nil -> ""
      image -> image.id
    end
  end
end
