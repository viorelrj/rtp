defmodule Sink do
  use GenServer

  def add_tweet(tweet) do
    GenServer.cast(__MODULE__, {:add_tweet, tweet})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def loop do
    spawn(fn ->
      Process.sleep(1000)
      GenServer.cast(__MODULE__, {:send})
    end)
  end

  @impl true
  def init(:ok) do
    tweets = []
    length = 0
    loop()
    {:ok, {tweets, length}}
  end

  @impl true
  def handle_cast({:add_tweet, tweet}, {tweets, length}) do
    tweets = [tweet | tweets]
    length = length + 1
    {:noreply, {tweets, length}}
  end

  def handle_cast({:send}, {tweets, length}) do
    IO.puts "stored"

    if (length > 0) do
      TweetsDatabase.store_tweets(tweets)
    end

    loop()
    {:noreply, {[], 0}}
  end
end
