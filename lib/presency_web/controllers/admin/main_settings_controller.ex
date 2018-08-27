defmodule PresencyWeb.Admin.MainSettingsController do
  use PresencyWeb, :controller
  alias Presency.CMS
  import PhoenixGon.Controller

  def edit(conn, _params) do
    main_settings = CMS.list_main_settings()
    changeset = CMS.change_main_settings(main_settings)
    page = CMS.list_paginated_images(1, 8)
    admin = conn.assigns.current_admin
    token = Phoenix.Token.sign(conn, "image_api_login", admin.id)
    conn = put_gon(conn, token: token)

    render(conn, "edit.html",
              images: page.entries,
              main_settings: main_settings,
              changeset: changeset,
              page: page,
              token: token)
  end

  def update(conn, %{"id" => id, "main_settings" => main_settings_params}) do
    old_settings = CMS.get_main_settings(id)

    case CMS.update_main_settings(old_settings, main_settings_params) do
      {:ok, new_main_settings} ->
        conn
        |> put_flash(:info, "Site settings updated successfully.")
        |> redirect(to: admin_main_settings_path(conn, :edit, main_settings: new_main_settings))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", main_settings: old_settings, changeset: changeset)
    end
  end
end