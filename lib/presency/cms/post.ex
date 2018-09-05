defmodule Presency.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Permissions.UserAccessProfile
  alias Presency.Permissions.UserAccessProfilesPermissions
  require Helpers.String
  require IEx

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
    many_to_many :tags, Presency.CMS.Tag, join_through: Presency.CMS.PostsTags, on_replace: :delete
    many_to_many :user_access_profiles, UserAccessProfile, join_through: UserAccessProfilesPermissions
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> Presency.Repo.preload([:category, :image, :post_status])
    |> cast(attrs, [:title, :content, :publicity, :meta_description, :url_id])
    |> validate_required([:title, :content, :publicity, :meta_description, :url_id])
    |> validate_url(:url_id)
    |> unique_constraint(:url_id)
    |> cast_assoc(:category)
    |> validate_not_empty(:title)
  end

  defp validate_url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case Helpers.String.valid_url?(url) do
        true -> []
        false -> [field: options[:message] || "Invalid URL"]
      end
    end)
  end

  defp validate_not_empty(changeset, field, options \\ []) do
    case Blankable.blank?(field) do
      true -> add_error(changeset, field, options[:message] || "This field can't be empty")
      false -> changeset
    end
  end
end
