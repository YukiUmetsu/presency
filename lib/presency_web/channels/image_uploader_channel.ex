defmodule PresencyWeb.ImageUploaderChannel do
  use PresencyWeb, :channel
  require Helpers.Images
  alias Presency.Administration
  alias Presency.Accounts
  require UUID

  def join("image_uploader", _payload, socket) do
    if authorized?(socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  def handle_in("image_uploader:new", %{"image"=>image, "content_type"=>content_type}, socket) do
    user_type = socket |> get_user_type
    uuid = user_type |> get_user_uuid(socket)

    with false <- Blankable.blank?(uuid),
        false <- Blankable.blank?(image),
        true <- is_bitstring(image)
     do
        extension = Helpers.Images.get_extension_from_content_type(content_type)
        avatar_img = write_avatar_to_file(uuid, user_type, image, extension)
        id = get_user_id(user_type, socket)

        case update_user_avatar(id, user_type, uuid, avatar_img) do
        {:ok, _user} ->
            reply = %{ message: "Image upload success" }
            {:reply, {:ok, reply}, socket}
        {:error, _} -> reply_error(socket)
        end
      else
        _ -> reply_error(socket)
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (image_uploader:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in(_, _payload, socket) do
    reply = %{ message: "I don't understand your question." }
    {:reply, {:error, reply}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket) do
    admin_user_id_exist = Map.has_key?(socket.assigns, :admin_user_id)
    user_id_exist = Map.has_key?(socket.assigns, :user_id)
    case {admin_user_id_exist, user_id_exist} do
      {false, false} -> false
      _ -> true
    end
  end

  defp get_user_type(socket) do
    case Blankable.blank?(socket.assigns.admin_user_id) do
      false -> "admin"
      true -> "user"
    end
  end

  defp get_user_id(user_type, socket) do
    case user_type do
      "admin" -> socket.assigns.admin_user_id
      _ -> socket.assigns.user_id
    end
  end

  defp get_user_uuid(user_type, socket) do
    case user_type do
      "admin" ->
        admin_user_id = socket.assigns.admin_user_id
        admin_user = Administration.get_admin_user!(admin_user_id)
        uuid = admin_user.uuid || UUID.uuid4(:hex)
        if admin_user.uuid != uuid do
          Administration.update_admin_user(admin_user, %{uuid: uuid})
        end
        uuid
      _ ->
        user_id = socket.assigns.user_id
        user = Accounts.get_user!(user_id)
        uuid = user.uuid || UUID.uuid4(:hex)
        if user.uuid != uuid do
          Accounts.update_user(user, %{uuid: uuid})
        end
        uuid
    end
  end

  defp reply_error(socket) do
    error_reply = %{ message: "Image upload failed"}
    {:reply, {:error, error_reply}, socket}
  end

  defp write_avatar_to_file(uuid, user_type, raw, ext) do
    Helpers.Images.save_avatar(%{base64: raw, format: ext}, user_type, uuid)
  end

  defp update_user_avatar(id, user_type, uuid, avatar_img) do
    params = %{"uuid" => "#{uuid}", "avatar_img"=> avatar_img.path}
    case user_type do
      "admin" ->
        admin_user = Administration.get_admin_user!(id)
        Administration.update_admin_user(admin_user, params)
      _ ->
        user = Accounts.get_user!(id)
        Accounts.update_user(user, params)
    end
  end

end
