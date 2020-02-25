defmodule Control.Controller do
  @moduledoc """
  Controller control API
  """

  @control_topic_filter ["esp", "control"]

  def get_control_topic_filter, do: @control_topic_filter

  def get_control_topic, do: get_control_topic_filter() |> Enum.join("/")

  def request_report do
    Tortoise.publish(GrowControl, get_control_topic(), "report")
  end

  defdelegate get_state(reply_to), to: Control.Controller.StatesKeeper

  def start_blinking, do: Tortoise.publish(GrowControl, get_control_topic(), "start blinking")

  def stop_blinking, do: Tortoise.publish(GrowControl, get_control_topic(), "stop blinking")
end
