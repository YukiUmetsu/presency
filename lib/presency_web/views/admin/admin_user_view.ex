defmodule PresencyWeb.Admin.AdminUserView do
  use PresencyWeb, :view
  alias Helpers.Images
  alias Presency.ImageUploader

  def show_avatar_thumb(admin_user) do
    raw(Images.show_admin_avatar(admin_user, :original, ["image", "is-48x48"]))
  end

  def user_exist(conn) do
    case Map.has_key?(conn.assigns, :admin_user) do
      true -> true
      _ -> false
    end
  end

  def user_has_avatar(conn) do
    case Blankable.blank?(conn.assigns.admin_user.avatar_img) do
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
         Images.show_admin_avatar(conn.assigns.admin_user, :original, ["image", "img-round"])
         |> raw()
    end
  end
end
