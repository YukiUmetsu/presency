defmodule PresencyWeb.Admin.MenuController do
  use PresencyWeb, :controller

  alias Presency.CMS
  alias Presency.CMS.Menu
  require IEx

  def index(conn, params) do
    menu = case CMS.get_active_menu() do
      nil -> create_default_menu(conn)
      {:ok, menu} -> menu
      {:error, error} -> create_default_menu(conn)
      menu -> menu
    end
    render conn, "index.html", menu: menu
  end


  defp create_default_menu(conn) do
    result = %{
      "status" => 1,
      "admin_id" => conn.assigns.current_admin.id,
      "menu_items" => [
        %{"title" => "Home", "link" => "#"},
        %{"title" => "Dropdown", "link" => "", "children" => [
          %{"title" => "Dropdown", "link" => "", "children" => [
             %{"title" => "Multi Dropdown", "link" => "#"},
             %{"title" => "Multi Dropdown", "link" => "#"},
             %{"title" => "Multi Dropdown", "link" => "#"},
             %{"title" => "Multi Dropdown", "link" => "#"},
          ]},
           %{"title" => "Dropdown", "link" => "#"},
           %{"title" => "Dropdown", "link" => "#"},
           %{"title" => "Dropdown", "link" => "#"},
           %{"title" => "Dropdown", "link" => "#"},
        ]},
        %{"title" => "Documentation", "link" => "#"},
        %{"title" => "Download", "link" => "#"}
      ]
    }
    |> CMS.create_menu()

    case result do
      {:ok, menu} -> menu
      {:error, _} -> :error
      nil -> :error
    end
  end
end
