defmodule Presency.CMS.MenuItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.CMS.MenuItem

  embedded_schema do
    field :title, :string
    field :link, :string
    field :children, {:array, :map}
  end

  @doc false
  def changeset(%MenuItem{} = menu_item, attrs) do
    menu_item
    |> cast(attrs, [:title, :link, :children])
    |> validate_required([:title])
  end

end
