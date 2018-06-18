defmodule Presency.Repo.Migrations.CreateUserAccessProfiles do
  use Ecto.Migration

  def change do
    create table(:user_access_profiles) do
      add :title, :string
      add :description, :text

      timestamps()
    end

  end
end
