defmodule Control.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      ControlWeb.Endpoint,
      # Starts a worker by calling: Control.Worker.start_link(arg)
      # {Control.Worker, arg},

      {Control.Controller.StatesKeeper, %{}},

      #
      {Tortoise.Connection,
       [
         client_id: GrowControl,
         server: {
           Tortoise.Transport.Tcp,
           host: Application.get_env(:control, :mqtt_host),
           port: Application.get_env(:control, :mqtt_port)
         },
         handler: {Control.Controller.StatesHandler, []}
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Control.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ControlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
