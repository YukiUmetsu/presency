defmodule PresencyWeb.Admin.CommentView do
  use PresencyWeb, :view
  require Helpers.Types
  require Helpers.Dates
  import Scrivener.HTML

  def get_by_admin(value) do
    case value do
      0 -> raw("<span class='icon has-text-danger'><i class='fa fa-times'></i></span")
      _ -> raw("<span class='icon has-text-success'><i class='fa fa-check'></i></span")
    end
  end

  def show_datetime(value) do
    Helpers.Dates.to_date_time_str(value)
  end
end
