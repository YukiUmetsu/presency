defmodule Presency.Repo.Migrations.AddParentCommentToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :parent_comment_id, references(:comments, on_delete: :delete_all)
    end

    create index(:comments, [:parent_comment_id])
  end
end
