defmodule Presency.CMS.Category do
  use Ecto.Schema
  import Ecto.Changeset


  schema "categories" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
