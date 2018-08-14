defmodule Presency.CMS.MainSettings do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Administration.AdminUser

  schema "main_settings" do
    field :copyright, :string
    field :facebook, :string
    field :favicon, :string
    field :google_plus, :string
    field :instagram, :string
    field :linkedin, :string
    field :logo, :string
    field :pinterest, :string
    field :site_sub_phrase, :string
    field :site_title, :string
    field :twitter, :string
    field :youtube, :string
    field :about_me_name, :string
    field :about_me_photo, :string
    field :about_me_description, :string
    field :about_me_link, :string

    timestamps()
  end

  @doc false
  def changeset(main_settings, attrs) do
    main_settings
    |> cast(attrs, [:site_title, :site_sub_phrase, :copyright, :logo, :favicon, :facebook, :twitter, :google_plus, :pinterest, :youtube, :instagram, :linkedin, :about_me_name, :about_me_photo, :about_me_description, :about_me_link])
    |> validate_required([:site_title, :copyright])
  end
end
