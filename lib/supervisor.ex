defmodule WorkerSupervisor do
  use GenServer

  def init(:ok) do
    refs = %{}
    {ref, pid} = add_process()
    refs = Map.put(refs, ref, pid)
    {:ok, refs}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def create() do
    GenServer.cast(__MODULE__, {:create})
  end

  @impl true
  def handle_cast({:create}, refs) do
    {ref, pid} = add_process()
    refs = Map.put(refs, ref, pid)

    Router.set_workers(Map.values(refs))
    {:noreply, refs}
  end

  defp  add_process() do
    {:ok, pid} = DynamicSupervisor.start_child(WorkerSupervisor, Worker)
    ref = Process.monitor(pid)
    {ref, pid}
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
