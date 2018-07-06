defmodule PresencyWeb.Admin.AdminUserController do
  use PresencyWeb, :controller

  alias Presency.Administration
  alias Presency.Accounts.User

  def index(conn, _params) do
    users = Administration.list_admin_users()

    conn
    |> render("index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Administration.change_admin_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin_user" => user_params}) do
    case Administration.create_admin_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
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
    changeset = Administration.change_admin_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "admin_user" => user_params}) do
    user = Administration.get_admin_user!(id)

    case Administration.update_admin_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Administration.get_admin_user!(id)
    {:ok, _user} = Administration.delete_admin_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end
end
