defmodule Presency.Repo.Migrations.AddAdminAccessProfileReferenceToAdminUsers do
  use Ecto.Migration

  def change do
    alter table(:admin_users) do
      add :admin_access_profile_id, references(:admin_access_profiles, on_delete: :nothing)
    end

    create index(:admin_users, [:admin_access_profile_id])
  end
end
