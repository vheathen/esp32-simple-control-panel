defmodule ControlWeb.TestLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>LiveView is awesome!</h1>
    <%= inspect(assigns, width: :infinity, pretty: true) %>
    """
  end

  def session_expired(socket) do
    # handle session expiration

    socket
  end
end
