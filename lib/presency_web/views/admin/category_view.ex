defmodule PresencyWeb.Admin.CategoryView do
  use PresencyWeb, :view

  def show_parent_category_title(parent_category_id, categories) do
    with {false, false} <- {Blankable.blank?(parent_category_id), Blankable.blank?(categories)}
      do
        parent_category_in_list = categories |> Enum.filter(fn(category) -> category.id == parent_category_id end)
        case parent_category_in_list do
          nil -> ""
          [] -> ""
          [parent_category] -> parent_category.title
        end
      else
        _ -> ""
      end
  end

end
