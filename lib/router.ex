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
    {:ok, pid} = Worker.start_link([])
    workers = workers ++ [pid]
    {:ok, pid} = Worker.start_link([])
    workers = workers ++ [pid]
    {:ok, pid} = Worker.start_link([])
    workers = workers ++ [pid]
    {:ok, pid} = Worker.start_link([])
    workers = workers ++ [pid]

    {:ok, workers}
  end

  @impl true
  def handle_cast({:handle_tweet, tweet}, workers) do
    [selected | other_workers] = workers
    Worker.handle(selected, tweet)
    workers = other_workers ++ [selected]
    {:noreply, workers}
  end
end
