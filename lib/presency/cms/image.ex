defmodule Presency.CMS.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Presency.Accounts.User
  alias Presency.CMS.Post
  alias Presency.Administration.AdminUser

  schema "images" do
    field :extension, :string
    field :filename, :string
    field :path, :string
    field :qquuid, :string
    field :size, :integer
    field :tag, :string
    field :caption, :string
    belongs_to :user, User
    belongs_to :admin_user, AdminUser
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:filename, :path, :extension, :tag, :size, :qquuid, :caption, :admin_user_id, :user_id, :post])
    |> validate_required([:filename, :path, :extension, :tag, :size, :qquuid])
  end
end
