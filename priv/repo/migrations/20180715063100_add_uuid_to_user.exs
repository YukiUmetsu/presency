defmodule Presency.Repo.Migrations.AddUuidToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :uuid, :text
    end
  end
end
