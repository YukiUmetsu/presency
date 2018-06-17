defmodule Presency.CMS.Comment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "comments" do
    field :by_admin, :integer
    field :content, :string
    field :user_id, :id
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :by_admin])
    |> validate_required([:content, :by_admin])
  end
end
