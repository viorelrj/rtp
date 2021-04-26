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
    index = rem(index, len)
    { Enum.at(items, index), index}
  end

  def set_workers(workers) do
    GenServer.cast(__MODULE__, {:set_workers, workers})
  end

  @impl true
  def handle_cast({:handle_tweet, tweet}, {workers, index}) do
    {selected, index} = get_worker(workers, index + 1)
    Worker.handle(selected, tweet)
    {:noreply, {workers, index}}
  end

  @impl true
  def handle_cast({:set_workers, workers}, {_workers, _index}) do
    {:noreply, {workers, 0}}
  end
end
