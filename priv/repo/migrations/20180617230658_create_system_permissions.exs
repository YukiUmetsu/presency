defmodule Presency.Repo.Migrations.CreateSystemPermissions do
  use Ecto.Migration

  def change do
    create table(:system_permissions) do
      add :resource, :string
      add :type, :string

      timestamps()
    end

  end
end
