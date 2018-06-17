defmodule Presency.CMS.PostStatus do
  use Ecto.Schema
  import Ecto.Changeset


  schema "post_statuses" do
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(post_status, attrs) do
    post_status
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
