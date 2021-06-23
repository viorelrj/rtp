defmodule Autoscaler do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, {}}
  end

  def set_count(count) do
    GenServer.cast(__MODULE__, {:set_count, count})
  end

  @impl true
  def handle_cast({:set_count, count}, _) do
    new_count = div(count, 10) + 1
    WorkerSupervisor.set_workers_count(new_count)
    {:noreply, {}}
  end

end
