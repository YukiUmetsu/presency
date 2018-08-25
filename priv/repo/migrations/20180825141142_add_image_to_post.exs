defmodule Presency.Repo.Migrations.AddImageToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :image_id, references(:images)
      add :url_id, :string
    end

    create unique_index(:posts, [:url_id])
  end
end
