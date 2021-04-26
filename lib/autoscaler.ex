defmodule Autoscaler do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    loop()
    {:ok, 0}
  end

  def loop do
    spawn(fn ->
      Process.sleep(1000)
      GenServer.cast(__MODULE__, {:refresh})
    end)
  end

  @impl true
  def handle_cast({:increase}, count) do
    {:noreply, count + 1}
  end

  @impl true
  def handle_cast({:refresh}, count) do
    new_count = div(count, 10) + 1
    WorkerSupervisor.set_workers_count(new_count)
    loop()
    {:noreply, 0}
  end

  def log_request do
    GenServer.cast(__MODULE__, {:increase})
  end

end
