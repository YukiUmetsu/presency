defmodule Presency.Repo.Migrations.AddMenus do
  use Ecto.Migration

  def change do
    create table(:menus) do
      add :status, :integer
      add :admin_user_id, references(:admin_users, on_delete: :nothing)
      add :menu_items, {:array, :map}

      timestamps()
    end

    create index(:menus, [:status])
  end
end
