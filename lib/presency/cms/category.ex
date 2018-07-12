defmodule Presency.CMS.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.CMS.Category
  alias Presency.CMS.Post

  schema "categories" do
    field :description, :string
    field :title, :string
    belongs_to :parent_category, Category
    has_many :children_categories, Category, foreign_key: :parent_category_id
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :description, :parent_category_id])
    |> validate_required([:title, :description])
  end
end
