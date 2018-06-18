defmodule Presency.Repo.Migrations.CreatePostsMetaKeywords do
  use Ecto.Migration

  def change do
    create table(:posts_meta_keywords) do
      add :post_id, references(:posts, on_delete: :nothing)
      add :meta_keyword_id, references(:meta_keywords, on_delete: :nothing)

      timestamps()
    end

    create index(:posts_meta_keywords, [:post_id])
    create index(:posts_meta_keywords, [:meta_keyword_id])
  end
end
