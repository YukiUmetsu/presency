defmodule Presency.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Permissions.UserAccessProfile
  alias  Presency.Permissions.UserAccessProfilesPermissions

  schema "posts" do
    field :content, :string
    field :publicity, :string
    field :title, :string
    field :meta_description, :string
    field :url_id, :string
    belongs_to :post_status, Presency.CMS.PostStatus
    belongs_to :category, Presency.CMS.Category
    has_one :image, Presency.CMS.Image
    has_many :comments, Presency.CMS.Comment
    has_many :comments_users, through: [:comments, :user]
    many_to_many :tags, Presency.CMS.Tag, join_through: Presency.CMS.PostsTags
    many_to_many :user_access_profiles, UserAccessProfile, join_through: UserAccessProfilesPermissions
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> Presency.Repo.preload([:category, :image, :post_status])
    |> cast(attrs, [:title, :content, :publicity, :meta_description, :url_id])
    |> validate_required([:title, :content, :publicity, :meta_description, :url_id])
    |> cast_assoc(:category)
  end

end
