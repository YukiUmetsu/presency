defmodule Presency.Permissions.AdminAccessProfilesPermission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Permissions.AdminAccessProfile
  alias Presency.Permissions.SystemPermission

  schema "admin_access_profiles_permissions" do
    belongs_to :admin_access_profile, AdminAccessProfile
    belongs_to :system_permission, SystemPermission

    timestamps()
  end

  @doc false
  def changeset(admin_access_profiles_permission, attrs \\ %{}) do
    admin_access_profiles_permission
    |> cast(attrs, [:admin_access_profile_id, :system_permission_id])
    |> validate_required([:admin_access_profile_id, :system_permission_id])
  end
end
