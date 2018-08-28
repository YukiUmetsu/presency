defmodule Helpers.Types do
  @moduledoc false

  def to_integer(value) do
    cond do
      is_binary(value) -> String.to_integer(value)
      is_integer(value) -> value
      true -> :error
    end
  end

  def boolean_to_integer(value \\ false) do
    case value do
      false -> 0
      _ -> 1
    end
  end

  def integer_to_boolean(value) do
    case value do
      0 -> false
      nil -> false
      _ -> true
    end
  end
end
