defmodule RTP do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: WorkerSupervisor, strategy: :one_for_one},
      {DynamicSupervisor, name: ConnectionSupervisor, strategy: :one_for_one},
      {Router, name: Router},
    ]

    Supervisor.start_link(children, strategy: :one_for_all)

    DynamicSupervisor.start_child(
      ConnectionSupervisor,
      {ConnectionItem, url: "127.0.0.1:6001/tweets/1"}
    )

    # DynamicSupervisor.start_child(
    #   ConnectionSupervisor,
    #   {ConnectionItem, url: "127.0.0.1:6001/tweets/2"}
    # )
  end
end
