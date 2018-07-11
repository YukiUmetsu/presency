defmodule Helpers.String do
  @moduledoc false

  def separate_words(value, separator) do
    cond do
      is_binary(value) ->
        String.split(value, separator)
        |> Enum.map(fn(keyword) ->
          String.trim(keyword)
        end)
      true -> []
    end
  end

  def trim_string_list(string_list \\ []) do
    string_list
    |> Enum.filter(fn(string) -> is_binary(string) == true  end)
    |> Enum.map(fn(string) -> String.trim(string) end)
    |> Enum.uniq
    |> Enum.filter(& "" != (&1))
  end
end
