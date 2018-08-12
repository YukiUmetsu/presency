defmodule PresencyWeb.Admin.CategoryController do
  use PresencyWeb, :controller

  alias Presency.CMS
  alias Presency.CMS.Category

  def index(conn, params) do
    page = CMS.list_paginated_categories(params["page"], 7)
    render conn, "index.html",
           page: page,
           categories: page.entries,
           page_number: page.page_number,
           page_size: page.page_size,
           total_pages: page.total_pages,
           total_entries: page.total_entries
  end

  def new(conn, _params) do
    categories = CMS.list_category_options()
    changeset = CMS.change_category(%Category{})
    render(conn, "new.html", changeset: changeset, categories: categories)
  end

  def create(conn, %{"category" => category_params}) do
    case CMS.create_category(category_params) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: admin_category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    categories = CMS.list_category_options()
    category = CMS.get_category!(id)
    changeset = CMS.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset, categories: categories)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = CMS.get_category!(id)

    case CMS.update_category(category, category_params) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: admin_category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = CMS.get_category!(id)
    {:ok, _category} = CMS.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: admin_category_path(conn, :index))
  end
end
