defmodule TimeManager.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimeManagerWeb.Telemetry,
      TimeManager.Repo,
      {DNSCluster,
       query: Application.get_env(:time_manager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TimeManager.PubSub},
      TimeManagerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: TimeManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    TimeManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
