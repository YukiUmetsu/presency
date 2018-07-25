defmodule PresencyWeb.ImageUploaderChannel do
  use PresencyWeb, :channel

  def join("image_uploader", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  def handle_in("image_uploader:new", %{"image" => image_binary}, socket) do
    reply = %{ message: "Image upload success" }
    {:reply, {:ok, reply}, socket}
  end

  def handle_in(_, _payload, socket) do
    reply = %{ message: "I don't understand your question." }
    {:reply, {:error, reply}, socket}
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

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
