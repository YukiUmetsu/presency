defmodule Presency.Repo.Migrations.CreateAdminAccessProfilesPermissions do
  use Ecto.Migration

  def change do
    create table(:admin_access_profiles_permissions) do
      add :admin_access_profile_id, references(:admin_access_profiles, on_delete: :nothing)
      add :system_permission_id, references(:system_permissions, on_delete: :nothing)

      timestamps()
    end

    create index(:admin_access_profiles_permissions, [:admin_access_profile_id])
    create index(:admin_access_profiles_permissions, [:system_permission_id])
  end
end
