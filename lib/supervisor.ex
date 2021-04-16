defmodule WorkerSupervisor do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  @impl true
  def init(:ok) do
    refs = %{}
    refs = add_process(refs, 5)

    Router.set_workers(Map.values(refs))
    {:ok, refs}
  end

  def create() do
    GenServer.cast(__MODULE__, {:create})
  end

  @impl true
  def handle_cast({:create}, refs) do
    refs = add_process(refs, 1)
    Router.set_workers(Map.values(refs))
    {:noreply, refs}
  end

  def  add_process(refs, count) do
    case count do
      0 -> refs
      _ ->
        {:ok, pid} = DynamicSupervisor.start_child(WorkerDynamicSupervisor, Worker)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, pid)
        WorkerSupervisor.add_process(refs, count - 1)
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, refs) do
    {_old_ref, refs} = Map.pop(refs, ref)
    Router.set_workers(Map.values(refs))
    {:noreply, refs}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
