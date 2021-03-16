defmodule RTP do
  use Application
  use GenServer

  @impl true
  def init(:ok) do
    {:ok, {}}
  end

  @impl true
  def start(_type, _args) do
    RTP.Supervisor.start_link(name: RTP.Supervisor)
    RTP.Consumer.add_address(RTP.Consumer, "127.0.0.1:6001/tweets/1")
    RTP.Consumer.add_address(RTP.Consumer, "127.0.0.1:6001/tweets/2")

    {:ok, self()}
  end

  @impl true
  def handle_info(_wildcard, state) do
    IO.puts("yeah, caught")
    {:noreply, state}
  end
end
