defmodule TcpServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: TcpServer.Worker.start_link(arg)
      # {TcpServer.Worker, arg},
      Supervisor.child_spec({Task, fn -> TcpServer.accept(port()) end}, restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TcpServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port do
    String.to_integer(System.get_env("PORT") || "40097")
  end
end
