defmodule Presency.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string

      timestamps()
    end

    create index(:tags, [:title], unique: true)
  end
end
