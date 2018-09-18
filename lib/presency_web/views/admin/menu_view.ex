defmodule PresencyWeb.Admin.MenuView do
  use PresencyWeb, :view
  require IEx

  def show_menu_items(menu_items) when is_list(menu_items) do
    Enum.reduce(menu_items, "", fn menu_item, acc ->
      acc <> show_menu_item(menu_item)
    end)
    |> raw()
  end

  def show_menu_item(menu_item) do
    case Blankable.blank?(menu_item.children) do
      true -> show_single_item(menu_item)
      false -> show_item_with_children(menu_item)
    end
  end

  def show_single_item(menu_item) do
    "<li><a href='#{menu_item.link}'>#{menu_item.title}</a></li>"
  end

  def show_item_with_children(menu_item) do
    add_first_li_with_children(menu_item)
    |> add_li_children(menu_item.children)
    |> add_end_li_with_children()
  end

  def add_first_li_with_children(menu_item) do
    "<li><a href='#{menu_item.link}'>#{menu_item.title}</a><i class='fa fa-angle-down'></i><ul class='sub'>"
  end

  def add_first_sub_li_with_children(html, menu_item) do
    html <> "<li><a href='#{menu_item["link"]}'>#{menu_item["title"]}</a><i class='fa fa-angle-right' style='color:#ddd'></i><ul class='sub-2'>"
  end

  def add_li_children(html, menu_items) when is_list(menu_items) do
    Enum.reduce(menu_items, html, fn menu_item, acc ->
      case has_children(menu_item) do
        false -> acc <> add_one_line_li(menu_item)
        true -> add_sub_li_children(acc, menu_item)
      end
    end)
  end

  def add_sub_li_children(html, menu_item) do
    html
    |> add_first_sub_li_with_children(menu_item)
    |> add_sub_li_child_item(menu_item["children"])
    |> add_end_li_with_children()
  end

  def add_sub_li_child_item(html, menu_items) do
    Enum.reduce(menu_items, html, fn menu_item, acc ->
      acc <> add_one_line_li(menu_item)
    end)
  end

  def add_sub_li_child_item(html, nil) do
    html
  end

  def add_one_line_li(menu_item) do
    "<li><a href='#{menu_item["link"]}'>#{menu_item["title"]}</a></li>"
  end

  def add_end_li_with_children(html) do
    html <> "</ul></li>"
  end

  def has_children(menu_item) do
    !Blankable.blank?(menu_item["children"])
  end
end
