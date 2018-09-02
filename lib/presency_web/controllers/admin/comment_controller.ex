defmodule PresencyWeb.Admin.CommentController do
  use PresencyWeb, :controller

  alias Presency.CMS
  alias Presency.CMS.Comment
  require IEx

  def index(conn, params) do
    page = CMS.list_paginated_comments(params["page"], 5)
    render(conn, "index.html",
      comments: page.entries,
      page: page,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  def new(conn, _params) do
    changeset = CMS.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    case CMS.create_comment(comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: admin_comment_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    comment = CMS.get_comment!(id)
    changeset = CMS.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = CMS.get_comment!(id)

    case CMS.update_comment(comment, comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: admin_comment_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = CMS.get_comment!(id)
    {:ok, _comment} = CMS.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: admin_comment_path(conn, :index))
  end
end
