defmodule Helpers.Images do
  @moduledoc false

  def show_avatar_thumb(user) do
    with false <- Blankable.blank?(user),
          false <- Blankable.blank?(user.avatar_img)
      do
        url = Presency.ImageUploader.url({user.avatar_img, user}, :thumb)
        "<img src=#{url} alt='presency usr avatar thumbnail' #{user.uuid}' class='image img-round is-48x48'/>"
      else
        _ -> ""
      end
  end

  def show_avatar_original(user) do
    with false <- Blankable.blank?(user),
         false <- Blankable.blank?(user.avatar_img)
      do
      url = Presency.ImageUploader.url({user.avatar_img, user})
      "<img src=#{url} alt='presency usr avatar thumbnail' #{user.uuid}' class='image img-round'/>"
    else
      _ -> ""
    end
  end
end
