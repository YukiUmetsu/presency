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
    has_many :comments, Presency.CMS.Comment
    has_many :comments_users, through: [:comments, :user]
    belongs_to :post_status, Presency.CMS.PostStatus
    belongs_to :category, Presency.CMS.Category
    many_to_many :tags, Presency.CMS.Tag, join_through: Presency.CMS.PostsTags
    many_to_many :meta_keywords, Presency.CMS.MetaKeyword, join_through: Presency.CMS.PostsMetaKeywords
    many_to_many :user_access_profiles, UserAccessProfile, join_through: UserAccessProfilesPermissions
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :publicity])
    |> validate_required([:title, :content, :publicity])
  end
end
