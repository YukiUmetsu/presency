defmodule PresencyWeb.Admin.UserView do
  use PresencyWeb, :view
  alias Helpers.Images
  import Scrivener.HTML

  def user_exist(conn) do
    case Map.has_key?(conn.assigns, :user) do
      true -> true
      _ -> false
    end
  end

  def user_has_avatar(conn) do
    case Blankable.blank?(conn.assigns.user.avatar_img) do
      true -> false
      _ -> true
    end
  end

  def show_user_avatar_image(conn) do
    case user_has_avatar(conn) do
      false ->
        img_src = static_path(conn, "/images/default-avatar.png")
        raw("<img id='avatar-image' src='#{img_src}' alt='your avatar'>")
      _ ->
        Images.show_admin_avatar(conn.assigns.user, ["image", "img-round"])
        |> raw()
    end
  end
end
