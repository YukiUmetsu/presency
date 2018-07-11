defmodule PresencyWeb.Admin.PostView do
  use PresencyWeb, :view
  import Helpers.Quill, only: [delta_to_html: 1, posts_content_to_html_array: 0]

  def post_content_to_html do
    delta_to_html("post_content")
  end

  def posts_content_to_array() do
    posts_content_to_html_array
    |> String.replace("\\", "")
  end
end
