defmodule PresencyWeb.Components.ImagePickerView do
  use PresencyWeb, :view
  alias Helpers.Images

  def get_path(image) do
    Images.get_path(image)
  end
end
