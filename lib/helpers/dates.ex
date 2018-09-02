defmodule Helpers.Dates do
  @moduledoc false

  def to_mdy(date) do
    "#{date.month}/#{date.day}/#{date.year}"
  end

  def to_date_time_str(date, show_seconds \\ false) do
    year = date.year |> to_two_digit
    month = date.month |> to_two_digit
    day = date.day |> to_two_digit
    hour = date.hour |> to_two_digit
    minute = date.minute |> to_two_digit
    second = date.second |> to_two_digit

    case show_seconds do
      false -> "#{month}/#{day}/#{year} #{hour}:#{minute}"
      true -> "#{month}/#{day}/#{year} #{hour}:#{minute}:#{second}"
    end
  end

  def to_two_digit(number) when is_integer(number) do
    number
    |> Integer.to_string
    |> String.pad_leading(2, "0")
  end
end
