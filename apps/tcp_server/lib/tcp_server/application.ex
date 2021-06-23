defmodule TCPServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      { Task.Supervisor, name: TCPServer.TaskSupervisor },
      { TCPServer.Subscribers, name: TCPServer.Subscribers },
      Supervisor.child_spec({Task, fn -> TCPServer.ClientApi.accept(4040) end}, id: :client_tasks, restart: :permanent),
      Supervisor.child_spec({Task, fn -> TCPServer.ServerApi.accept(4041) end}, id: :server_tasks, restart: :permanent),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TCPServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
