defmodule TweetsDatabase do
  use GenServer

  def store_tweets(tweets) do
    GenServer.cast(__MODULE__, {:store_tweets, tweets})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, conn} = Mongo.start_link(database: "rtp", url: "mongodb://127.0.0.1:4001")
  end

  @impl true
  def handle_cast({:store_tweets, tweets}, connection) do
    Mongo.insert_many(connection, "tweets", tweets)
  {:noreply, connection}
  end
end
