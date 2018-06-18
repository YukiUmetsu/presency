defmodule Presency.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :publicity, :string
      add :meta_description, :text
      timestamps()
    end
  end
end
