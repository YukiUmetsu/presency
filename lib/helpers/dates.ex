defmodule Helpers.Dates do
  @moduledoc false

  def to_mdy(date) do
    "#{date.month}/#{date.day}/#{date.year}"
  end

  def to_date_time_str(date, show_seconds \\ false) do
    case show_seconds do
      false -> "#{date.month}/#{date.day}/#{date.year} #{date.hour}:#{date.minute}"
      true -> "#{date.month}/#{date.day}/#{date.year} #{date.hour}:#{date.minute}:#{date.second}"
    end
  end
end
