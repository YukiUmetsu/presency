defmodule Presency.CMS.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.CMS.Comment
  alias Presency.Accounts.User
  alias Presency.CMS.Post

  schema "comments" do
    field :by_admin, :integer
    field :content, :string
    belongs_to :user, User
    belongs_to :post, Post
    has_many :children_comments, Comment, foreign_key: :parent_comment_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :by_admin])
    |> validate_required([:content, :by_admin])
  end
end
