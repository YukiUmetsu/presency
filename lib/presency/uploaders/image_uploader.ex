defmodule Presency.ImageUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  def __storage, do: Arc.Storage.Local

  # To add a thumbnail version:
  @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
   def validate({file, _rest}) do
     ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
   end

  # Define a thumbnail transformation:
   def transform(:thumb, __) do
     {:convert, "-strip -thumbnail 250X250 -gravity center -extent 250X250 -format jpg", :jpg}
     #{:convert, "-strip -thumbnail 250x250"}
   end

   def transform(:original, __) do
    {:convert, "-strip -gravity center -format jpg"}
    #{:convert, "-strip -gravity center"}
   end

  # Override the persisted filenames:
   def filename(version, {__file, __scope}) do
     "#{version}"
   end

  # Override the storage directory:
   def storage_dir(__version, {__file, scope}) do
      with false <- Blankable.blank?(scope),
           false <- Blankable.blank?(scope.uuid)
        do
          user_type = case Map.has_key?(scope, :admin_access_profile_id) do
            false -> "user"
            _ -> "admin"
          end
          "priv/static/uploads/#{user_type}/#{scope.uuid}/avatar"
        else
        _ -> "priv/static/uploads/unknown/"
      end
   end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
