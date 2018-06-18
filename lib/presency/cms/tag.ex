defmodule Presency.CMS.Tag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tags" do
    field :title, :string
    many_to_many :posts, Presency.CMS.Post, join_through: Presency.CMS.PostsTags

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
