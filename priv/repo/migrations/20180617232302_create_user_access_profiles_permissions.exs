defmodule Presency.Repo.Migrations.CreateUserAccessProfilesPermissions do
  use Ecto.Migration

  def change do
    create table(:user_access_profiles_permissions) do
      add :post_id, references(:posts, on_delete: :nothing)
      add :user_access_profile_id, references(:user_access_profiles, on_delete: :nothing)

      timestamps()
    end

    create index(:user_access_profiles_permissions, [:post_id])
    create index(:user_access_profiles_permissions, [:user_access_profile_id])
  end
end
