defmodule Presency.Permissions.UserAccessProfilesPermissions do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.CMS.Post
  alias Presency.Permissions.UserAccessProfile

  schema "user_access_profiles_permissions" do
    belongs_to :post, Post
    belongs_to :user_access_profile, UserAccessProfile

    timestamps()
  end

  @doc false
  def changeset(user_access_profiles_permissions, params \\ %{}) do
    user_access_profiles_permissions
    |> cast(params, [:post_id, :user_access_profile_id])
    |> validate_required([:post_id, :user_access_profile_id])
  end
end
