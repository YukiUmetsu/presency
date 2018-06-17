defmodule Presency.Administration.AdminUser do
  use Ecto.Schema
  import Ecto.Changeset


  schema "admin_users" do
    field :avatar_img, :string
    field :display_name, :string
    field :email, :string
    field :first_name, :string
    field :introduction_content, :string
    field :last_name, :string
    field :password, :string
    field :admin_access_profile_id, :id

    timestamps()
  end

  @doc false
  def changeset(admin_user, attrs) do
    admin_user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :avatar_img, :introduction_content, :display_name])
    |> validate_required([:first_name, :last_name, :email, :password, :avatar_img, :introduction_content, :display_name])
  end
end
