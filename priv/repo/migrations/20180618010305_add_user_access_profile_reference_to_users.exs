defmodule Presency.Repo.Migrations.AddUserAccessProfileReferenceToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_access_profile_id, references(:user_access_profiles, on_delete: :nothing)
    end

    create index(:users, [:user_access_profile_id])
  end
end
