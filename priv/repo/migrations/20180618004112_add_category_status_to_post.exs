defmodule Presency.Repo.Migrations.AddCategoryStatusToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :category_id, references(:categories, on_delete: :delete_all)
      add :post_status_id, references(:post_statuses, on_delete: :delete_all)
    end

    create index(:posts, [:category_id])
    create index(:posts, [:post_status_id])
  end
end
