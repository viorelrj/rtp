defmodule TCPServer.ServerApi do
  require Logger

  @port 4041

  def start() do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, active: false, reuseaddr: true])
    Logger.info "Accepting Server connections on port #{@port}..."
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(TCPServer.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> parse(socket)

    serve(socket)
  end

  defp read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} -> data
      {:error, :closed} -> TCPServer.Subscribers.unsubscribe(socket)
    end
  end

  defp parse(line, sock) do
    {topic, content} = Mediator.decode_topic(line)
    subscribers = TCPServer.Subscribers.topic_subscribers(topic)
    Enum.each(subscribers, fn subscriber -> :gen_tcp.send(subscriber, content) end)
  end
end
