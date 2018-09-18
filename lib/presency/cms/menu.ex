defmodule Presency.CMS.Menu do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Administration.AdminUser
  alias Presency.CMS.MenuItem


  schema "menus" do
    field :status, :integer
    belongs_to :admin_user, AdminUser
    embeds_many :menu_items, MenuItem, on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(menu, attrs) do
    menu
    |> cast(attrs, [:status, :admin_user_id])
    |> validate_required([:status])
    |> cast_embed(:menu_items, with: &MenuItem.changeset/2)
  end

end
