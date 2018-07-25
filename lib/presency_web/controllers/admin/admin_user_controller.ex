defmodule PresencyWeb.Admin.AdminUserController do
  use PresencyWeb, :controller

  alias Presency.Administration
  alias Presency.Administration.AdminUser
  alias Presency.Structs.PathInfo
  require UUID
  require Helpers.Images
  require IEx

  def index(conn, _params) do
    admin_users = Administration.list_admin_users_order_by_id()

    conn
    |> render("index.html", admin_users: admin_users)
  end

  def new(conn, _params) do
    changeset = Administration.change_admin_user(%AdminUser{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin_user" => user_params}) do
    avatar_info = get_avatar_info_from_params(user_params)
    user_params =
      user_params
      |> Map.drop(["avatar_img"])
      |> Map.put("uuid", "#{UUID.uuid4(:hex)}")

    path_info = %PathInfo{
      ok_path: :show,
      ok_message: "User created successfully.",
      error_path: "new.html"
    }
    case Administration.create_admin_user(user_params) do
      {:ok, user} ->
        avatar_info = Helpers.Images.save_temp_avatar(avatar_info, user.id)
        update_user_with_avatar(conn, user, avatar_info, user_params, path_info)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Administration.get_admin_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Administration.get_admin_user!(id)
    token = Phoenix.Token.sign(conn, "socket_login", user.id)
    changeset = Administration.change_admin_user(user)
    conn = assign(conn, :user, user)
    render(conn, "edit.html", user: user, changeset: changeset, token: token)
  end

  def update(conn, %{"id" => id, "admin_user" => user_params}) do
    avatar_info = get_avatar_info_from_params(user_params)
    user = Administration.get_admin_user!(id)
    avatar_info = Helpers.Images.save_temp_avatar(avatar_info, user.id)

    path_info = %PathInfo{
      ok_path: :show,
      ok_message: "User updated successfully.",
      error_path: "edit.html"
    }
    update_user_with_avatar(conn, user, avatar_info, user_params, path_info)
  end

  def delete(conn, %{"id" => id}) do
    user = Administration.get_admin_user!(id)
    {:ok, _user} = Administration.delete_admin_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_admin_user_path(conn, :index))
  end

  defp update_admin_user(conn, user, user_params, %PathInfo{} = path_info) do
    case Administration.update_admin_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, path_info.ok_message)
        |> redirect(to: admin_admin_user_path(conn, path_info.ok_path, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, path_info.error_path, user: user, changeset: changeset)
    end
  end

  defp add_user_to_img_filename(avatar_info, user) do
    filename = "admin__#{user.uuid}__#{avatar_info.filename}"
    Map.put(avatar_info, :filename, filename)
  end

  defp update_user_with_avatar(conn, user, avatar_info, user_params, path_info) do
    case avatar_info do
      nil ->
        conn
        |> put_flash(:info, path_info.ok_message)
        |> redirect(to: admin_admin_user_path(conn, path_info.ok_path, user))
      _ ->
        avatar_info = add_user_to_img_filename(avatar_info, user)
        user_params = Map.put(user_params, "avatar_img", avatar_info)
        update_admin_user(conn, user, user_params, path_info)
    end
  end

  defp get_avatar_info_from_params(user_params) do
    user_params
    |> Helpers.Images.get_avatar_info_from_params
    |> Helpers.Images.get_avatar_info_from_base64_str
  end

end
