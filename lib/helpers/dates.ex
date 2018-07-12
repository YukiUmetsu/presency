defmodule Helpers.Dates do
  @moduledoc false

  def to_mdy(date) do
    "#{date.month}/#{date.day}/#{date.year}"
  end

  def to_date_time_str(date) do
    "#{date.month}/#{date.day}/#{date.year} #{date.hour}:#{date.minute}"
  end
end
