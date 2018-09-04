defmodule Presency.CMS.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.CMS.Comment
  alias Presency.Accounts.User
  alias Presency.CMS.Post
  alias Presency.Administration.AdminUser

  schema "comments" do
    field :by_admin, :integer
    field :content, :string
    belongs_to :user, User
    belongs_to :admin_user, AdminUser
    belongs_to :post, Post
    has_many :children_comments, Comment, foreign_key: :parent_comment_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :by_admin, :parent_comment_id, :user_id, :post_id, :admin_user_id])
    |> validate_required([:content, :by_admin])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:admin_user_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:parent_comment_id)
  end
end
