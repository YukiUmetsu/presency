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
    admin_user = conn.assigns.current_admin
    changeset = Administration.change_admin_user(%AdminUser{})
    token = Phoenix.Token.sign(conn, "socket_login", admin_user.id)
    render(conn, "new.html", changeset: changeset, token: token)
  end

  def create(conn, %{"admin_user" => user_params}) do
    uuid = UUID.uuid4(:hex)
    avatar_img = move_tmp_avatar_file(user_params, uuid)
    user_params = user_params
                  |> Map.drop(["avatar_img"])
                  |> Map.put("uuid", "#{uuid}")
                  |> Map.put("avatar_img", avatar_img)

    case Administration.create_admin_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_admin_user_path(conn, :edit, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Administration.get_admin_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    admin_user = Administration.get_admin_user!(id)
    token = Phoenix.Token.sign(conn, "socket_login", admin_user.id)
    changeset = Administration.change_admin_user(admin_user)
    render(conn, "edit.html", admin_user: admin_user, changeset: changeset, token: token)
  end

  def update(conn, %{"id" => id, "admin_user" => user_params}) do
    avatar_info = get_avatar_info_from_params(user_params)
    admin_user = Administration.get_admin_user!(id)
    avatar_info = case avatar_info do
      "" -> nil
      nil -> nil
      _ -> Helpers.Images.save_avatar(avatar_info, "admin", admin_user.uuid)
    end

    path_info = %PathInfo{
      ok_path: :show,
      ok_message: "User updated successfully.",
      error_path: "edit.html"
    }
    update_user_with_avatar(conn, admin_user, avatar_info, user_params, path_info)
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

  defp update_user_with_avatar(conn, user, avatar_info, user_params, path_info) do
    case avatar_info do
      nil ->
        update_admin_user(conn, user, user_params, path_info)
        conn
        |> put_flash(:info, path_info.ok_message)
        |> redirect(to: admin_admin_user_path(conn, path_info.ok_path, user))
      _ ->
        user_params = Map.put(user_params, "avatar_img", avatar_info.path)
        update_admin_user(conn, user, user_params, path_info)
    end
  end

  defp get_avatar_info_from_params(user_params) do
    user_params
    |> Helpers.Images.get_avatar_info_from_params
    |> Helpers.Images.get_avatar_info_from_base64_str
  end

  defp move_tmp_avatar_file(user_params, uuid) do
    case user_params["temp_avatar_img"] do
      nil -> ""
      "" -> ""
      tmp_img_path ->
        new_dir = Helpers.Images.get_avatar_dir("admin", uuid)
        filename = Path.basename(tmp_img_path)
        new_path = "#{new_dir}/#{filename}"
        avatar_img = Helpers.Files.move_file(tmp_img_path, new_dir, new_path)
    end
  end

end
