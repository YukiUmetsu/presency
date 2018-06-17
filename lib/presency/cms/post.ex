defmodule Presency.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :content, :string
    field :publicity, :string
    field :title, :string
    field :category_id, :id
    field :status_id, :id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :publicity])
    |> validate_required([:title, :content, :publicity])
  end
end
