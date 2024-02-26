defmodule Classrag.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClassragWeb.Telemetry,
      Classrag.Repo,
      {DNSCluster, query: Application.get_env(:classrag, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Classrag.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Classrag.Finch},
      # Start a worker by calling: Classrag.Worker.start_link(arg)
      # {Classrag.Worker, arg},
      # Start to serve requests, typically the last entry
      ClassragWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Classrag.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClassragWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
