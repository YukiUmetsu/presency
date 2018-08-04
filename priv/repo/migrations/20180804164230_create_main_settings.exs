defmodule Presency.Repo.Migrations.CreateMainSettings do
  use Ecto.Migration

  def change do
    create table(:main_settings) do
      add :site_title, :string
      add :site_sub_phrase, :string
      add :copyright, :string
      add :logo, :string
      add :favicon, :string
      add :facebook, :string
      add :twitter, :string
      add :google_plus, :string
      add :pinterest, :string
      add :youtube, :string
      add :instagram, :string
      add :linkedin, :string
      add :about_me_name, :string
      add :about_me_photo, :string
      add :about_me_description, :text
      add :about_me_link, :string

      timestamps()
    end
  end
end
