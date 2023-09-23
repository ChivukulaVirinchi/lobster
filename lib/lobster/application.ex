defmodule Lobster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LobsterWeb.Telemetry,
      # Start the Ecto repository
      Lobster.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Lobster.PubSub},
      # Start Finch
      {Finch, name: Lobster.Finch},
      # Start the Endpoint (http/https)
      LobsterWeb.Endpoint
      # Start a worker by calling: Lobster.Worker.start_link(arg)
      # {Lobster.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lobster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LobsterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
