defmodule Presency.Repo.Migrations.AddCaptionToImage do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :caption, :string
    end
  end
end
