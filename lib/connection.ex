defmodule Connection do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, {}}
  end

  @impl true
  def handle_cast({:message, message}, state) do
    IO.puts message
    {:noreply, state}
  end

  @spec handle_message(Connection, any) :: :ok
  def handle_message(Connection, message) do
    GenServer.cast(Connection, {:message, message})
  end
end

defmodule ConnectionItem do
  use Agent

  def start_link(opts) do
    {url} = parse_options(opts)
    EventsourceEx.new(url, stream_to: self())
    recv()
  end

  defp parse_options(opts) do
    url = opts[:url]
    {url}
  end

  defp recv() do
    receive do
      tweet -> handle(tweet.data)
    end

    recv()
  end

  defp handle(data) do
    case serialize(data) do
      {:ok, content} -> handle_success(content)
      {:error} -> handle_error()
    end
  end

  defp serialize(data) do
    case JSON.decode(data) do
      {:ok, content} -> {:ok, content}
      {:error, _error} -> handle_error()
    end
  end

  defp handle_success(content) do
    message = content["message"]["tweet"]["text"]
    Connection.handle_message(Connection, message)
  end

  defp handle_error() do
    {:error}
  end
end
