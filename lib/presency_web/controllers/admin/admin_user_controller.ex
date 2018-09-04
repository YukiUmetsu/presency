defmodule PresencyWeb.Admin.AdminUserController do
  use PresencyWeb, :controller

  alias Presency.Administration
  alias Presency.Administration.AdminUser
  alias Presency.Structs.PathInfo
  require UUID
  require Helpers.Images
  require IEx

  def index(conn, params) do
    page = Administration.list_paginated_admin_users(params["page"], 5)
    render conn, "index.html",
           page: page,
           admin_users: page.entries,
           page_number: page.page_number,
           page_size: page.page_size,
           total_pages: page.total_pages,
           total_entries: page.total_entries
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
    admin_user = Administration.get_admin_user!(id)
    user_params = Map.drop(user_params, ["temp_avatar_img", "avatar_img"])

    case Administration.update_admin_user(admin_user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: admin_admin_user_path(conn, :edit, admin_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", admin_user: admin_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Administration.get_admin_user!(id)
    {:ok, _user} = Administration.delete_admin_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_admin_user_path(conn, :index))
  end

  defp move_tmp_avatar_file(user_params, uuid) do
    case user_params["temp_avatar_img"] do
      nil -> ""
      "" -> ""
      tmp_img_path ->
        new_dir = "priv/static" <> Helpers.Images.get_avatar_dir("admin", uuid)
        extension = Path.extname(tmp_img_path)
        new_path = "#{new_dir}original#{extension}"
        avatar_img = Helpers.Files.move_file(tmp_img_path, new_dir, new_path)
    end
  end

end
