defmodule PresencyWeb.Api.ImageManagerView do
  use PresencyWeb, :view

  def render("index.json", %{pages: pages}) do
    %{data: render_many(pages, HelloWeb.PageView, "page.json")}
  end

  def render("new.json", %{response: response}) do
    response
  end

  def render("page.json", %{page: page}) do
    %{title: page.title}
  end
end
