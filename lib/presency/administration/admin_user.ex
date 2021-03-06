defmodule Presency.Administration.AdminUser do
  use Ecto.Schema
  import Ecto.Changeset
  require IEx


  schema "admin_users" do
    field :avatar_img, :string
    field :display_name, :string
    field :email, :string
    field :first_name, :string
    field :introduction_content, :string
    field :last_name, :string
    field :password, :string
    field :uuid, :string
    belongs_to :admin_access_profile, Presency.Permissions.AdminAccessProfile
    has_many :images, Presency.CMS.Image

    timestamps()
  end

  @doc false
  def changeset(admin_user, attrs) do
    admin_user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :avatar_img, :introduction_content, :display_name, :uuid])
    |> unique_constraint(:email)
    |> unique_constraint(:uuid)
    |> validate_required([:first_name, :last_name, :email, :uuid])
  end
end
