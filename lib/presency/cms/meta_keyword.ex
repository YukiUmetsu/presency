defmodule Presency.CMS.MetaKeyword do
  use Ecto.Schema
  import Ecto.Changeset


  schema "meta_keywords" do
    field :title, :string
    many_to_many :posts, Presency.CMS.Post, join_through: Presency.CMS.PostsMetaKeywords

    timestamps()
  end

  @doc false
  def changeset(meta_keyword, attrs) do
    meta_keyword
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
