defmodule RTP do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Counter, name: Counter},
      {Autoscaler, name: Autoscaler},
      {TweetsDatabase, name: TweetsDatabase},
      {Sink, name: Sink},
      {DynamicSupervisor, name: DBSupervisor, strategy: :one_for_one},
      {DynamicSupervisor, name: WorkerDynamicSupervisor, strategy: :one_for_one},
      {DynamicSupervisor, name: ConnectionSupervisor, strategy: :one_for_one},
      {Router, name: Router},
      {WorkerSupervisor, name: WorkerSupervisor},
    ]


    Supervisor.start_link(children, strategy: :one_for_all)

     DynamicSupervisor.start_child(
       ConnectionSupervisor,
       {ConnectionItem, url: "127.0.0.1:4000/tweets/1"}
     )

    DynamicSupervisor.start_child(
      ConnectionSupervisor,
      {ConnectionItem, url: "127.0.0.1:4000/tweets/2"}
    )
  end
end
