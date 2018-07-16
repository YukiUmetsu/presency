defmodule Presency.Repo.Migrations.AddUuidToAdminUser do
  use Ecto.Migration

  def change do
    alter table(:admin_users) do
      add :uuid, :text
    end
  end
end
