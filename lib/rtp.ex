defmodule RTP do
  use Application

  @impl true
  def start(_type, _args) do
    RTP.Supervisor.start_link(name: RTP.Supervisor)
    RTP.Consumer.add_address(RTP.Consumer, "127.0.0.1:6001/tweets/1")
    RTP.Consumer.add_address(RTP.Consumer, "127.0.0.1:6001/tweets/2")

    {:ok, self()}
  end
end
