defmodule Router do
  use GenServer

  def route(tweet) do
    GenServer.cast(__MODULE__, {:handle_tweet, tweet})
  end

  @impl true
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    workers = []
    index = 0

    {:ok, {workers, index}}
  end

  defp get_worker(items, index) do
    len = length items
    index = rem(len, index)
    Enum.at(items, index)
  end

  def set_workers(workers) do
    GenServer.cast(__MODULE__, {:set_workers, workers})
  end

  @impl true
  def handle_cast({:handle_tweet, tweet}, {workers, index}) do
    index = index + 1
    selected = get_worker(workers, index)
    Worker.handle(selected, tweet)
    {:noreply, {workers, index}}
  end

  def handle_cast({:set_workers_count, workers}, {_workers, index}) do
    {:noreply, {workers, index}}
  end
end
