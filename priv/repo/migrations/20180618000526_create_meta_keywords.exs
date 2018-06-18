defmodule Presency.Repo.Migrations.CreateMetaKeywords do
  use Ecto.Migration

  def change do
    create table(:meta_keywords) do
      add :title, :string

      timestamps()
    end

  end
end
