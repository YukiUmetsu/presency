defmodule Presency.Repo.Migrations.AddImagesDateIndexes do
  use Ecto.Migration

  def change do
    create index(:images, ["updated_at DESC NULLS LAST"])
  end
end
