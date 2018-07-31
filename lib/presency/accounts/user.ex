defmodule Presency.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :avatar_img, :string
    field :display_name, :string
    field :email, :string
    field :fb_token, :string
    field :first_name, :string
    field :ggl_token, :string
    field :last_name, :string
    field :password, :string
    field :username, :string
    field :uuid, :string
    belongs_to :user_access_profile, Presency.Permissions.UserAccessProfile
    has_many :comments, Presency.CMS.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :fb_token, :ggl_token, :avatar_img, :username, :display_name, :uuid])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> unique_constraint(:uuid)
    |> validate_required([:email, :username])
  end
end
