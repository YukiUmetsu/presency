defmodule Presency.CMS.PostsMetaKeywords do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts_meta_keywords" do
    belongs_to :post, Presency.CMS.Post
    belongs_to :meta_keyword, Presency.CMS.MetaKeyword

    timestamps()
  end

  @doc false
  def changeset(posts_meta_keywords, attrs) do
    posts_meta_keywords
    |> cast(attrs, [])
    |> validate_required([])
  end
end
