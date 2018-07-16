defmodule PresencyWeb.Admin.AdminUserView do
  use PresencyWeb, :view
  alias Helpers.Images

  def show_avatar_thumb(admin_user) do
    raw(Images.show_avatar_thumb(admin_user))
  end
end
