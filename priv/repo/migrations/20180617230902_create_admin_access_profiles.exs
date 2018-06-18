defmodule Presency.Repo.Migrations.CreateAdminAccessProfiles do
  use Ecto.Migration

  def change do
    create table(:admin_access_profiles) do
      add :title, :string
      add :description, :text

      timestamps()
    end

  end
end
