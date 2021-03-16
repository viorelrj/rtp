defmodule RTP.Consumer do
  use GenServer

  @impl true
  def init(:ok) do
    addresses = %{}
    refs = %{}
    funnel = spawn(fn -> RTP.ConsumerFunnel.recv() end)
    Process.monitor(funnel)
    {:ok, {addresses, refs, funnel}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def handle_cast({:add_address, address}, {addresses, refs, funnel}) do
    if Map.has_key?(addresses, address) do
      {:noreply, {addresses, refs, funnel}}
    else
      {:ok, pid} =
        Task.Supervisor.start_child(RTP.SSESupervisor, fn ->
          EventsourceEx.new(address, stream_to: funnel)
        end)

      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, address)
      addresses = Map.put(addresses, address, pid)
      {:noreply, {addresses, refs, funnel}}
    end
  end

  @impl true
  def handle_info({:DOWN, reference, :process, pid, :normal}, state) do
    IO.puts("test")
    {:noreply, state}
  end

  @impl true
  def handle_info(:KILL, state) do
    IO.puts("Handled Kill")
    {:noreply, state}
  end

  def add_address(module, address) do
    GenServer.cast(module, {:add_address, address})
  end

  def kill() do
    IO.puts("handle kill")
  end
end

defmodule RTP.ConsumerFunnel do
  def recv() do
    receive do
      tweet -> manage(tweet.data)
    end

    recv()
  end

  defp manage(data) do
    case serialize(data) do
      {:ok, content} -> content |> print()
      {:ignore} -> :noop
    end
  end

  defp print(data) do
    message = data["message"]["tweet"]["text"]
    IO.puts(message)
    IO.puts(RTP.Analysis.get_score(message))
  end

  defp serialize(data) do
    case JSON.decode(data) do
      {:ok, content} -> handle_success(content)
      {:error, _value} -> handle_error()
    end
  end

  defp handle_error() do
    RTP.Consumer.kill()
    {:ignore}
  end

  defp handle_success(content) do
    {:ok, content}
  end
end
