defmodule PresencyWeb.Api.ImageManagerController do
  use PresencyWeb, :controller
  alias Helpers.Files
  alias Helpers.Images
  alias Presency.CMS
  require IEx

  def index(conn, params) do
    IO.inspect(params)
    render(conn, "index.json")
  end

  def create(conn, %{"qqfile" => qqfile, "qqfilename" => filename, "qqtotalfilesize" => size, "qquuid" => qquuid}) do
    distDir = create_distination_dir()
    distPath = "#{distDir}/#{filename}"
    response = case Files.copy_file(qqfile.path, distDir, distPath) do
        {:ok, result_path} ->
          attrs = create_image_map_from_qfile(qqfile, result_path, filename, size, qquuid, "gallery")
          CMS.create_image(attrs)
          path_info = Images.split_dir_filename(result_path)
          Images.strip_origilal_image(path_info.dir, path_info.filename)
          %{success: true}
        {:error, reason} -> %{error: reason}
      end
    render(conn, "new.json", response: response)
  end

  def create_image_map_from_qfile(qqfile, path, filename, size, qquuid, tag \\"") do
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
end
