defmodule Presency.Repo.Migrations.CreateAdminUsers do
  use Ecto.Migration

  def change do
    create table(:admin_users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password, :string
      add :avatar_img, :text
      add :introduction_content, :text
      add :display_name, :string

      timestamps()
    end
  end
end
