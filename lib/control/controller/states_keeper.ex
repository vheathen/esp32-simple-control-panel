defmodule Control.Controller.StatesKeeper do
  use GenServer

  alias ControlWeb.Endpoint, as: Controller

  @controller_status_topic "controller:status"
  @mqtt_status_topic "mqtt:status"

  @me __MODULE__

  # require Logger

  def get_state(reply_to) do
    GenServer.cast(@me, {:get_state, reply_to})
  end

  def start_link(opts \\ %{}) do
    GenServer.start_link(@me, opts, name: @me)
  end

  #######
  # API #
  #######

  def init(_args) do
    Controller.subscribe(@controller_status_topic)
    Controller.subscribe(@mqtt_status_topic)

    {:ok, %{mqtt: "disconnected", controller: "unknown"}}
  end

  def handle_cast(
        {:get_state, reply_to},
        %{mqtt: mqtt_event, controller: controller_event} = state
      ) do
    Process.send(reply_to, %{topic: @mqtt_status_topic, event: mqtt_event}, [])

    Process.send(
      reply_to,
      %{topic: @controller_status_topic, event: controller_event},
      []
    )

    {:noreply, state}
  end

  def handle_info(%{topic: @mqtt_status_topic, event: event}, state) do
    {:noreply, %{state | mqtt: event}}
  end

  def handle_info(%{topic: @controller_status_topic, event: event}, state) do
    {:noreply, %{state | controller: event}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
