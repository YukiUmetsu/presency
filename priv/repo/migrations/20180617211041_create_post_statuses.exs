defmodule Presency.Repo.Migrations.CreatePostStatuses do
  use Ecto.Migration

  def change do
    create table(:post_statuses) do
      add :description, :string

      timestamps()
    end

  end
end
