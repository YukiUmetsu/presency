defmodule PresencyWeb.Admin.MainSettingsController do
  use PresencyWeb, :controller
  alias Presency.CMS

  def edit(conn, _params) do
    main_settings = CMS.list_main_settings()
    changeset = CMS.change_main_settings(main_settings)

    conn
    |> render("edit.html", main_settings: main_settings, changeset: changeset)
  end

  def update(conn, %{"id" => id, "main_settings" => main_settings_params}) do
    old_settings = CMS.get_main_settings(id)

    case CMS.update_category(old_settings, main_settings_params) do
      {:ok, new_main_settings} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: admin_main_settings_path(conn, :edit, new_main_settings))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", main_settings: old_settings, changeset: changeset)
    end
  end


end