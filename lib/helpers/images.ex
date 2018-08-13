defmodule Helpers.Images do
  @moduledoc false
  require Plug.Upload
  alias Helpers.Files
  require IEx

  def get_admin_avatar_url(user) do
    String.trim_leading(user.avatar_img, "priv/static")
  end

  def get_user_avatar_url(user) do
   String.trim_leading(user.avatar_img, "/priv/static")
  end

  def show_admin_avatar(user, html_classes \\ ["image", "img-round", ""]) do
    with false <- Blankable.blank?(user),
          false <- Blankable.blank?(user.avatar_img)
      do
        url = get_admin_avatar_url(user)
        class_string = Enum.join(html_classes, " ")
        "<img id='avatar-image' src=#{url} alt='user avatar thumbnail' #{user.uuid}' class='#{class_string}'/>"
      else
        _ -> ""
      end
  end

  def get_avatar_info_from_params(user_params) do
    case Map.fetch(user_params, "avatar_img") do
      {:ok, avatar_info} -> avatar_info
      :error -> nil
    end
  end

  def get_avatar_info_from_base64_str(string \\ "") do
    result = try do
      Regex.named_captures(~r{data:image/(?<format>.*);base64,(?<base64>.*)}, string)
    rescue
      _ -> nil
    end

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

  def save_temp_avatar(attr, user_type, uuid) do
    case is_valid_image(attr) do
      false -> nil
      true ->
        {:ok, data} = Base.decode64(attr.base64)
        temp_dir = "priv/static" <> get_avatar_temp_dir(user_type, uuid)
        Files.create_dir(temp_dir)
        path = temp_dir <> "original.#{attr.format}"
        case Files.write_avatar_to_file(path, data, attr.format) do
          :error -> nil
          image_info ->
            strip_origilal_image("/#{temp_dir}", image_info.filename)
            image_info
        end
    end
  end

  def save_avatar(attr, user_type, uuid) do
    case is_valid_image(attr) do
      false -> nil
      true ->
        {:ok, data} = Base.decode64(attr.base64)
        directory = "priv/static" <> get_avatar_dir(user_type, uuid)
        Files.create_dir(directory)
        path = directory <> "original.#{attr.format}"
        case Files.write_avatar_to_file(path, data, attr.format) do
          :error -> nil
          image_info ->
            strip_origilal_image("/#{directory}", image_info.filename)
            image_info
        end
    end
  end

  def is_valid_image(image_attr) do
    with false <- Blankable.blank?(image_attr),
         false <- Blankable.blank?(image_attr.base64),
         false <- Blankable.blank?(image_attr.format)
      do
        true
      else
        _ -> false
      end
  end

  def get_extension_from_content_type(content_type \\ "image/jpg") do
    str_list = content_type
               |> String.trim()
               |> String.split("/", trim: true)

    case Enum.count(str_list) do
      0 -> "jpg"
      1 -> str_list |> Enum.at(0)
      _ -> str_list |> Enum.at(-1)
    end
  end

  def get_extension_from_filename(filename \\ ".jpg") do
     str_list = String.trim(filename) |> String.split(".", trim: true)
     case Enum.count(str_list) do
        0 -> "jpg"
        1 -> Enum.at(str_list, 0)
        _ -> str_list |> Enum.at(-1)
      end
  end

  def get_avatar_dir(user_type, uuid) do
    "/uploads/#{user_type}/#{uuid}/avatar/"
  end

  def create_avatar_dir(user_type, uuid) do
    Files.create_dir("priv/static/uploads/#{user_type}/#{uuid}/avatar")
  end

  def avatar_dir_exists?(user_type, uuid) do
    File.exists?("priv/static/uploads/#{user_type}/#{uuid}/avatar")
  end

  def get_avatar_temp_dir(user_type, uuid) do
    "priv/static/temp/#{user_type}/#{uuid}/avatar"
  end

  def temp_avatar_dir_exists?(user_type, uuid) do
    File.exists?("priv/static/temp/#{user_type}/#{uuid}/avatar")
  end

  def create_temp_avatar_dir(user_type, uuid) do
    case File.mkdir_p("priv/static/temp/#{user_type}/#{uuid}/avatar") do
      :ok -> :ok
      {:error, _} -> :error
    end
  end

  def create_temp_avatar_file(attr, user_type, uuid) do
    if temp_avatar_dir_exists?(user_type, uuid) == false do
      create_temp_avatar_dir(user_type, uuid)
    end
    save_temp_avatar(attr, user_type, uuid)
  end

  def strip_origilal_image(directory, filename) do
    filename = filename |> strip_training_num()
    first_char = String.slice(directory, 0, 1)
    dir = case first_char do
      "/" -> String.trim_trailing("#{directory}", "/")
      _ -> "/" <> String.trim_trailing("#{directory}", "/")
    end
    directory = System.cwd <> dir
    System.cmd("convert", ["-strip", "#{filename}", "#{filename}"], cd: directory)
  end

  def strip_training_num(filename) do
    # trim after ?
    String.replace(filename, ~r/(.)\?.*/, "\\1")
  end

  def split_dir_filename(path \\ "") do
    str_list = String.split(path, "/")
    filename = Enum.at(str_list, -1)
    dir = String.trim_trailing(path, filename) |> String.trim_trailing("/")
    %{dir: dir, filename: filename}
  end

  def get_path(image) do
    String.trim_leading(image.path, "priv/static")
  end
end
