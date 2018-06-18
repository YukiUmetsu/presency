defmodule Presency.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password, :string
      add :fb_token, :string
      add :ggl_token, :string
      add :avatar_img, :text
      add :username, :string
      add :display_name, :string

      timestamps()
    end
  end
end
