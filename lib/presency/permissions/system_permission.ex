defmodule Presency.Permissions.SystemPermission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Permissions.AdminAccessProfile
  alias Presency.Permissions.AdminAccessProfilesPermission

  schema "system_permissions" do
    field :resource, :string
    field :type, :string
    many_to_many :admin_access_profiles, AdminAccessProfile, join_through: AdminAccessProfilesPermission

    timestamps()
  end

  @doc false
  def changeset(system_permission, attrs) do
    system_permission
    |> cast(attrs, [:resource, :type])
    |> validate_required([:resource, :type])
  end
end
