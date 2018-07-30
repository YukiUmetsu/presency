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

  def write_image_to_file(path, data, ext) do
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


end
