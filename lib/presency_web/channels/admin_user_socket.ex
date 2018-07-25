defmodule PresencyWeb.AdminUserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", PresencyWeb.RoomChannel
  channel "image_uploader", PresencyWeb.ImageUploaderChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a admin_user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "socket_login", token, max_age: 1209600) do
      {:ok, admin_user_id} ->
        socket = assign(socket, :admin_user_id, admin_user_id)
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given admin_user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given admin_user:
  #
  #     PresencyWeb.Endpoint.broadcast("user_socket:#{admin_user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
