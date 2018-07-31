defmodule PresencyWeb.LayoutView do
  use PresencyWeb, :view
  import PhoenixGon.View

  def get_current_admin_avatar_url(conn) do
    current_admin = get_current_admin(conn)
    with false <- Blankable.blank?(current_admin),
        false <- Blankable.blank?(current_admin.avatar_img)
      do
        static_path(conn, String.trim_leading(current_admin.avatar_img, "priv/static"))
      else
        true -> static_path(conn, "/images/default-avatar.png")
        :error -> static_path(conn, "/images/default-avatar.png")
        _ -> static_path(conn, "/images/default-avatar.png")
    end
  end

  def get_current_admin_name(conn) do
    current_admin = get_current_admin(conn)
    with false <- Blankable.blank?(current_admin),
        false <- Blankable.blank?(current_admin.display_name)
    do
      "#{current_admin.display_name}"
    else
      true -> "default" <> " name"
      _ -> "default" <> " name"
    end
  end

  def get_current_admin(conn) do
    conn.assigns.current_admin
  end
end
