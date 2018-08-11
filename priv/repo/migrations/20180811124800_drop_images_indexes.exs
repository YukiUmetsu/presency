defmodule Presency.Repo.Migrations.DropImagesIndexes do
  use Ecto.Migration

  def change do
    drop index(:images, [:user_id])
    drop index(:images, [:admin_user_id])
  end
end
