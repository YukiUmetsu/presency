defmodule Helpers.Posts do
  @moduledoc false

  def show_category_title(category_id, categories) do
    with {false, false} <- {Blankable.blank?(category_id), Blankable.blank?(categories)}
      do
        category_in_list = categories |> Enum.filter(fn(category) -> category.id == category_id end)
        case category_in_list do
          nil -> ""
          [] -> ""
          [category] -> category.title
        end
    else
      _ -> ""
    end
  end

  @spec show_title_in_one_line(Enumerable) :: string
  def show_title_in_one_line(resources \\ []) do
    case resources do
      resources ->
        resources
        |> Enum.map(fn(resource) -> resource.title end)
        |> Enum.join(", ")
      _ -> ""
    end
  end

end
