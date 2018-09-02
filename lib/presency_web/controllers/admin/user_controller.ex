defmodule PresencyWeb.Admin.UserController do
  use PresencyWeb, :controller

  alias Presency.Accounts
  alias Presency.Accounts.User
  require IEx

  def index(conn, params) do
    page = Accounts.list_paginated_users(params["page"], 5)
    render conn, "index.html",
           page: page,
           users: page.entries,
           page_number: page.page_number,
           page_size: page.page_size,
           total_pages: page.total_pages,
           total_entries: page.total_entries
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    token = Phoenix.Token.sign(conn, "socket_login", user.id)
    changeset = Accounts.change_user(user)
    conn = assign(conn, :user, user)
    render(conn, "edit.html", user: user, changeset: changeset, token: token)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end

end
