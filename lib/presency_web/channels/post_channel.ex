defmodule PresencyWeb.PostChannel do
  use PresencyWeb, :channel
  alias Presency.Administration
  alias Presency.Accounts
  alias Presency.CMS
  require UUID
  require IEx

  def join("post", _payload, socket) do
    if authorized?(socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  def handle_in("post:url_exist", %{"url"=>url}, socket) do
      cond do
        false == valid_url?(url) ->
          reply = %{ message: "Invalid URL", exist: true }
          {:reply, {:error, reply}, socket}

        false == url_exist?(url) ->
          reply = %{ message: "URL Not Exists", exist: false }
          {:reply, {:ok, reply}, socket}

        true ->
          reply = %{ message: "URL Exists", exist: true }
          {:reply, {:error, reply}, socket}
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
    error_reply = %{ message: "Post Connection failed"}
    {:reply, {:error, error_reply}, socket}
  end

  defp valid_url?(url) do
    url =~ ~r/^[a-zA-Z0-9_-]+$/
  end

  defp url_exist?(url) do
    case CMS.get_post_by_url_id(url) do
      {:ok, _post} -> true
      {:error, _} -> false
      nil -> false
    end
  end

end
