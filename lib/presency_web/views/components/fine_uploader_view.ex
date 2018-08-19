defmodule PresencyWeb.Components.FineUploader do
  use PresencyWeb, :view

  def get_current_admin_id(conn) do
    case Map.has_key?(conn.assigns, :current_admin) do
      false -> ""
      true -> conn.assigns.current_admin.id
    end
  end

  def get_current_user_id(conn) do
    case Map.has_key?(conn.assigns, :current_user) do
      false -> ""
      true -> conn.assignscurrent_user.id
    end
  end
end
