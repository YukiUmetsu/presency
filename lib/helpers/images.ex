defmodule Helpers.Images do
  @moduledoc false
  alias Presency.ImageUploader
  require Plug.Upload
  require IEx

  def get_avatar_url(user, type) do
    ImageUploader.url({user.avatar_img, user}, type) |> String.trim_leading("/priv/static")
  end

  def show_avatar(user, type, html_classes \\ ["image", "img-round", ""]) do
    with false <- Blankable.blank?(user),
          false <- Blankable.blank?(user.avatar_img)
      do
        url = get_avatar_url(user, type)
        class_string = Enum.join(html_classes, " ")
        "<img src=#{url} alt='presency usr avatar thumbnail' #{user.uuid}' class='#{class_string}'/>"
      else
        _ -> ""
      end
  end

  def get_avatar_info_from_params(user_params) do
    case Map.fetch(user_params, "avatar_img") do
      {:ok, avatar_info} -> avatar_info
      {:error, __} -> nil
    end
  end

  def get_avatar_info_from_base64_str(string \\ "") do
     result = Regex.named_captures(~r{data:image/(?<format>.*);base64,(?<base64>.*)}, string)
     approved_ext = ["png", "jpg", "jpeg", "tiff", "bmp", "gif"]

     with false <- Blankable.blank?(result),
          false <- Blankable.blank?(result["format"]),
          false <- Blankable.blank?(result["base64"]),
          true <- Enum.member?(approved_ext, result["format"])
       do
        %{
           content_type: "image/"<>result["format"],
            format: result["format"],
           filename: "temp_avatar."<>result["format"],
           base64: result["base64"]
         }
       else
       _ -> nil
     end
  end

  def save_temp_avatar(attr, id) do
    with false <- Blankable.blank?(attr),
          false <- Blankable.blank?(attr.base64),
          false <- Blankable.blank?(attr.format)
      do
        dir_path = "./priv/static/temp/#{id}"
        File.mkdir(dir_path)
        {:ok, data} = Base.decode64(attr.base64)
        path = dir_path <> "/temp.#{attr.format}"
        case File.open(path, [:write]) do
          {:ok, file} ->
            IO.binwrite(file, data)
            File.close(file)
            %{
              content_type: "image/#{attr.format}",
              filename: "temp_avatar.#{attr.format}",
              path: "./priv/static/temp/#{id}"
            }
          {:error, _} -> nil
        end
      else
        _ -> nil
    end
  end

end
