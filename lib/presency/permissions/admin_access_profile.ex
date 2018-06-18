defmodule Presency.Permissions.AdminAccessProfile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Permissions.SystemPermission
  alias Presency.Permissions.AdminAccessProfilesPermission

  schema "admin_access_profiles" do
    field :description, :string
    field :title, :string
    has_many :admin_users, Presency.Administration.AdminUser
    many_to_many :system_permissions, SystemPermission, join_through: AdminAccessProfilesPermission

    timestamps()
  end

  @doc false
  def changeset(admin_access_profile, attrs) do
    admin_access_profile
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
