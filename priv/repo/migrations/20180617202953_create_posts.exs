defmodule Presency.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :publicity, :string
      add :category_id, references(:categories, on_delete: :nothing)
      add :status_id, references(:statuses, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:category_id])
    create index(:posts, [:status_id])
  end
end
