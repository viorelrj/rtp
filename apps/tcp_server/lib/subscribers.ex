defmodule TCPServer.Subscribers do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    topic_map = %{}

    {:ok, topic_map}
  end

  @impl true
  def handle_cast({:subscribe, topic, connection}, topic_map) do
    subscribers = topic_map[topic] || []
    new_map = Map.put(topic_map, topic, [connection | subscribers])
    IO.puts(Map.keys(topic_map))
    {:noreply, new_map}
  end

  @impl true
  def handle_cast({:unsubscribe, sock}, topic_map) do
    res = %{}
    for {topic, subscribers} <- topic_map do
      Map.put(res, topic, Enum.filter(subscribers, fn x -> x != sock end))
    end
    {:noreply, res}
  end

  @impl true
  def handle_call({:get_subscribers, topic}, _from, topic_map) do
    {:reply, topic_map[topic], topic_map}
  end

  @spec topic_subscribers(any) :: any
  def topic_subscribers(topic) do
    GenServer.call(__MODULE__, {:get_subscribers, topic})
  end

  def unsubscribe(socket) do
    GenServer.cast(__MODULE__, {:unsubscribe, socket})
  end

  def subscribe(topic, connection) do
    GenServer.cast(__MODULE__, {:subscribe, topic, connection})
  end
end
