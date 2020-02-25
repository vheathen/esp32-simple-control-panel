# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :control,
  # please mind single quotes
  mqtt_host: '192.168.10.150',
  mqtt_port: 1883

# Configures the endpoint
config :control, ControlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZCAulbkxba18+akiIzCTw/Kmod/hd4Ol91HL8nM/AFD11792CFM9h2Qe27HKQAUK",
  render_errors: [view: ControlWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Control.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "yKuB4TrjwUnkPdRbnt1E89bCXJVKz/ND"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
