defmodule PodViewer do
  @moduledoc """
  This application launches a trivial webserver listening on port 8080
  which fetches the k8s pod listing endpoint and returns it to the
  requestor.
  """

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: PodViewer.Handlers.Pods,
       options: [port: 8080]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PodViewer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
