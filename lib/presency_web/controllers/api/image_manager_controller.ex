defmodule PresencyWeb.Api.ImageManagerController do
  use PresencyWeb, :controller
  alias Helpers.Files
  alias Helpers.Images
  alias Presency.CMS
  alias Presency.Administration
  alias Presency.Accounts
  require IEx

  def index(conn, %{"page" => page, "page_size" => page_size, "token" => token}) do
    case is_valid_token(token) do
      true -> render_image(conn, page, page_size)
      false -> render_error(conn)
    end
  end

  def render_image(conn, given_page, page_size) do
    page = CMS.list_paginated_images(given_page, page_size)
    images_data = %{
      images: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
    render conn, "index.json", images_data: images_data
  end

  def render_error(conn) do
    render conn, "index.json", error: %{error: "invalid user"}
  end

  def create(conn, image_info) do
    case token_verify("image_api_login", image_info["token"]) do
      true -> add_image(conn, image_info)
      false -> render_error(conn)
    end
  end

  def create_image_map_from_qfile(qqfile, path, size, qquuid, tag \\"") do
    extension = qqfile.filename |> Images.get_extension_from_filename()
    size = size |> String.to_integer()
    %{
    "extension" => extension,
    "filename" => qqfile.filename,
    "path" => path,
    "size" => size,
    "qquuid" => qquuid,
    "tag" => tag,
    "admin_user_id" => nil,
    "user_id" => nil,
    "post_id" => nil
    }
  end

  def create_distination_dir() do
    date = Date.utc_today()
    "priv/static/uploads/images/#{date.year}/#{date.month}/#{date.day}"
  end

  defp add_image(conn, %{
    "qqfile" => qqfile,
    "qqfilename" => filename,
    "qqtotalfilesize" => size,
    "qquuid" => qquuid,
    "caption" => caption,
    "tag"=>tag,
    "token" => _token,
    "admin_user" => admin_user,
    "user" => user
  }) do
    distDir = create_distination_dir()
    distPath = "#{distDir}/#{filename}"
    response = case Files.copy_file(qqfile.path, distDir, distPath) do
      {:ok, result_path} ->

        attrs = create_image_map_from_qfile(qqfile, result_path, size, qquuid, "gallery")
                |> add_user_info(admin_user, user)
                |> add_image_info(caption, tag)

        CMS.create_image(attrs)
        path_info = Images.split_dir_filename(result_path)
        Images.strip_origilal_image(path_info.dir, path_info.filename)
        %{success: true}
      {:error, reason} -> %{error: reason}
    end
    render(conn, "new.json", response: response)
  end

  defp add_image_info(attrs, caption, tag) do
    attrs = case Blankable.blank?(caption) do
      true -> attrs
      false -> Map.put(attrs, "caption", caption)
    end

    case Blankable.blank?(tag) do
      true -> attrs
      false -> Map.put(attrs, "tag", tag)
    end
  end

  defp add_user_info(attrs, admin_user_id \\ "", user_id \\ "") do
    attrs = with false <- Blankable.blank?(admin_user_id),
         {_parsed_id, _} <- Integer.parse(admin_user_id),
         admin_user <- Administration.get_admin_user!(admin_user_id)
      do
        Map.put(attrs, "admin_user", admin_user)
        Map.put(attrs, "admin_user_id", admin_user.id)
      else
        _ -> attrs
    end

    with false <- Blankable.blank?(user_id),
                 {_parsed_id, _} <- Integer.parse(user_id),
                 user <- Accounts.get_user!(user_id)
      do
      Map.put(attrs, "user", user)
      Map.put(attrs, "user_id", user.id)
    else
      _ -> attrs
    end
  end

  def is_valid_token(token) do
    is_valid = Enum.map(["image_api_login", "socket_login"], fn key ->
      token_verify(key, token)
    end)

    case is_valid do
      [false, false] -> false
      nil -> false
      [true, false] -> true
      [false, true] -> true
      _ -> false
    end
  end

  def token_verify(key, token) do
    case Phoenix.Token.verify(PresencyWeb.Endpoint, key, token, max_age: 86400) do
      {:ok, _} -> true
      {_, _} -> false
    end
  end
end
