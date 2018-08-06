defmodule Presency.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :filename, :string
      add :path, :string
      add :extension, :string
      add :tag, :string
      add :size, :integer
      add :qquuid, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :admin_user_id, references(:admin_users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end

    create index(:images, [:user_id])
    create index(:images, [:admin_user_id])
    create index(:images, [:post_id])
  end
end
