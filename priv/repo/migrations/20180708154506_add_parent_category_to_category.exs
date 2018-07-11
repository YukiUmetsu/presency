defmodule Presency.Repo.Migrations.AddParentCategoryToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :parent_category_id, references(:categories, on_delete: :delete_all)
    end

    create index(:categories, [:parent_category_id])
  end
end
