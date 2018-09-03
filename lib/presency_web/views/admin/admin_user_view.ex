defmodule PresencyWeb.Admin.AdminUserView do
  use PresencyWeb, :view
  alias Helpers.Images

  def show_avatar_thumb(admin_user) do
    raw(Images.show_admin_avatar(admin_user, ["image", "is-48x48"]))
  end

  def user_exist(conn) do
    case Map.has_key?(conn.assigns, :admin_user) do
      true -> true
      _ -> false
    end
  end

  def user_has_avatar(admin_user) do
    with false <- Blankable.blank?(admin_user),
      false <- Blankable.blank?(admin_user.avatar_img) do
        true
      else
        _ -> false
    end
  end

  def show_user_avatar_image(conn, admin_user) do
    case user_has_avatar(admin_user) do
      false ->
        img_src = static_path(conn, "/images/default-avatar.png")
        raw("<img id='avatar-image' src='#{img_src}' alt='your avatar'>")
       _ ->
         Images.show_admin_avatar(admin_user, ["image", "img-round"])
         |> raw()
    end
  end
end
