defmodule Helpers.Files do
  @moduledoc false
  require IEx

  def create_dir(temp_dir) do
    with false <- Blankable.blank?(temp_dir),
         false <- File.exists?(temp_dir) do

      case File.mkdir_p(temp_dir) do
        :ok -> :ok
        {:error, _} -> :error
      end
    else
      _ -> :error
    end
  end

  def write_avatar_to_file(path, data, ext) do
    case File.open(path, [:write]) do
      {:ok, file} ->
        IO.binwrite(file, data)
        File.close(file)
        rand = :rand.uniform(9999999999)
        %{
          content_type: "image/#{ext}",
          filename: "original.#{ext}",
          path: path <> "?#{rand}",
          extension: ext
        }
      {:error, _} -> :error
    end
  end

  def create_file(dir, path, data) do
    case File.exists?(dir) do
      false -> File.mkdir_p(dir)
      _ -> ""
    end

    case File.open(path, [:write]) do
      {:ok, file} ->
        IO.binwrite(file, data)
        File.close(file)
        path
      {:error, _} -> :error
    end
  end

  def copy_file(srcPath, distDir, distPath, index \\ 0, max_try \\ 5) do
    create_dir(distDir)
    case {index <= max_try, File.exists?(distPath)} do
      {true, false} ->
        File.cp_r(srcPath, distPath)
        rand = :rand.uniform(9999999999)
        {:ok, "#{distPath}?#{rand}"}

      {true, true} ->
        new_path = add_index_to_path(distPath, index+1)
        copy_file(srcPath, distDir, new_path, index+1, max_try)

      {false, _} -> {:error, "reached to max tries"}
    end
  end

  def move_file(srcPath, distDir, distPath) do
    case Helpers.Files.copy_file(srcPath, distDir, distPath) do
      {:ok, path} ->
        File.rm_rf(srcPath)
        path
      {:error, _} -> :error
    end
  end

  def add_index_to_path(path, index \\ 1) do
    str_array = String.split(path, ".")
    ext = Enum.at(str_array, -1)
    path_front = String.trim_trailing(path, ".#{ext}")
    "#{path_front}-#{index}.#{ext}"
  end

  def get_temp_dir(type \\ "images") do
    year = DateTime.utc_now.year
    month = DateTime.utc_now.month
    day = DateTime.utc_now.day
    "priv/static/uploads/temp/#{type}/#{year}/#{month}/#{day}"
  end

  def split_dir_filename(path \\ "") do
    filename = Path.basename(path)
    ext = Path.extname(path)
    dir = Path.dirname(path)
    %{dir: dir, filename: filename, ext: ext}
  end
end
