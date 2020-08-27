defmodule Asis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any(), any()) :: {:ok, pid} | {:error, any()}
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Asis.Repo,
      # Start the Telemetry supervisor
      AsisWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Asis.PubSub},
      # Start the Endpoint (http/https)
      AsisWeb.Endpoint
      # Start a worker by calling: Asis.Worker.start_link(arg)
      # {Asis.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Asis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(any(), any(), any()) :: :ok
  def config_change(changed, _new, removed) do
    AsisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
