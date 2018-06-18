defmodule Presency.Permissions.UserAccessProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_access_profiles" do
    field :description, :string
    field :title, :string
    has_many :users, Presency.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(user_access_profile, attrs) do
    user_access_profile
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
