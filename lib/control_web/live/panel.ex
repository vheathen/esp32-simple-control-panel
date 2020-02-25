defmodule ControlWeb.Panel do
  use Phoenix.LiveView

  alias ControlWeb.Endpoint, as: Endpoint
  alias Control.Controller

  @controller_status_topic "controller:status"
  @mqtt_status_topic "mqtt:status"

  def mount(_params, _session, socket) do
    Endpoint.subscribe(@controller_status_topic)
    Endpoint.subscribe(@mqtt_status_topic)

    Controller.get_state(self())

    {:ok, assign(socket, %{mqtt: :unknown, controller: :unknown})}
  end

  def render(assigns) do
    ~L"""
    <h1 style="text-align: center;">LED control</h1>

    <div style="width: 100%; text-align: center;">
      <div style="width: 50%; float: left;">
        <h3>MQTT connection status</h3>
        <p class="dot <%= @mqtt %>"></p>
        <p><%= @mqtt %></p>
      </div>

      <div style="width: 50%; float: left;">
        <h3>LED status</h3>
        <p class="dot <%= @controller %>"></p>
        <p><%= @controller %></p>
      </div>
    </div>
    <div style="text-align: center;">
        <button id="<%= @controller %>" phx-click="blinking_action">
          <%=
            if @controller == :blinking do
              "Stop blinking"
            else
              "Start blinking"
            end
            %>
          </button>
    </div>
    """
  end

  def handle_event("blinking_action", _value, %{assigns: %{controller: :blinking}} = socket) do
    Controller.stop_blinking()
    {:noreply, socket}
  end

  def handle_event("blinking_action", _value, socket) do
    Controller.start_blinking()
    {:noreply, socket}
  end

  def handle_info(%{topic: @mqtt_status_topic, event: "unknown"}, socket) do
    {:noreply, assign(socket, %{mqtt: :unknown})}
  end

  def handle_info(%{topic: @mqtt_status_topic, event: "connected"}, socket) do
    {:noreply, assign(socket, %{mqtt: :connected})}
  end

  def handle_info(%{topic: @mqtt_status_topic, event: "disconnected"}, socket) do
    {:noreply, assign(socket, %{mqtt: :disconnected, controller: :unknown})}
  end

  def handle_info(%{topic: @controller_status_topic, event: "unknown"}, socket) do
    {:noreply, assign(socket, %{controller: :unknown})}
  end

  def handle_info(%{topic: @controller_status_topic, event: "vanished"}, socket) do
    {:noreply, assign(socket, %{controller: :disconnected})}
  end

  def handle_info(%{topic: @controller_status_topic, event: "hold"}, socket) do
    {:noreply, assign(socket, %{controller: :hold})}
  end

  def handle_info(%{topic: @controller_status_topic, event: "blinking"}, socket) do
    {:noreply, assign(socket, %{controller: :blinking})}
  end

  def handle_info(%{event: "state"}, socket) do
    {:noreply, socket}
  end
end
