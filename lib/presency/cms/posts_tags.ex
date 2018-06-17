defmodule Presency.CMS.PostsTags do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts_tags" do
    field :post_id, :id
    field :tag_id, :id

    timestamps()
  end

  @doc false
  def changeset(posts_tags, attrs) do
    posts_tags
    |> cast(attrs, [])
    |> validate_required([])
  end
end
