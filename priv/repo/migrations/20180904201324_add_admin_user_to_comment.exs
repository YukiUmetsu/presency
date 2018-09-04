defmodule Presency.Repo.Migrations.AddAdminUserToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :admin_user_id, references(:admin_users)
    end
  end
end