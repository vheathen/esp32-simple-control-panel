defmodule Control.Controller.StatesHandler do
  use Tortoise.Handler

  alias ControlWeb.Endpoint, as: PubSub
  alias Control.Controller

  require Logger

  @tag inspect(__MODULE__)

  @status_topic "esp/status"
  @status_topic_filter String.split(@status_topic, "/")

  @controller_status_topic "controller:status"
  @mqtt_status_topic "mqtt:status"

  def init(args) do
    {:ok, args}
  end

  # `status` will be either `:up` or `:down`; you can use this to
  # inform the rest of your system if the connection is currently
  # open or closed; tortoise should be busy reconnecting if you get
  # a `:down`
  def connection(status, state)

  def connection(:up, state) do
    log("mqtt connection established")

    {:ok, _} = Tortoise.Connection.subscribe(GrowControl, [{@status_topic, 0}])

    PubSub.broadcast(@mqtt_status_topic, "connected", %{})

    Controller.request_report()

    {:ok, state}
  end

  def connection(:down, state) do
    log("mqtt connection finished")

    PubSub.broadcast(@mqtt_status_topic, "disconnected", %{})

    {:ok, state}
  end

  def handle_message(@status_topic_filter, "blinking", state) do
    log("got status message from esp: 'blinking'")

    PubSub.broadcast(@controller_status_topic, "blinking", %{})

    {:ok, state}
  end

  def handle_message(@status_topic_filter, "hold", state) do
    log("got status message from esp: 'hold'")

    PubSub.broadcast(@controller_status_topic, "hold", %{})

    {:ok, state}
  end

  def handle_message(@status_topic_filter, "vanished", state) do
    log("got status message from esp: 'vanished'")

    PubSub.broadcast(@controller_status_topic, "vanished", %{})

    {:ok, state}
  end

  def handle_message(topic, payload, state) do
    log(
      "got unhandled message from esp on topic '#{inspect(topic)}' with message '#{
        inspect(payload)
      }'"
    )

    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    log("mqtt subscribed to '#{inspect(topic_filter)}' with status #{inspect(status)}")

    {:ok, state}
  end

  def terminate(reason, _state) do
    log("mqtt terminated with reason #{inspect(reason)}")

    :ok
  end

  defp log(message) do
    Logger.debug("#{@tag}: #{inspect(message)}")
  end
end
