defmodule TCPServer.ClientApi do
  require Logger
  @port 4040

  def start() do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, active: false, reuseaddr: true])
    Logger.info "Accepting connection on port #{@port}..."
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
    case String.split(line) do
      ["subscribe", topic] -> TCPServer.Subscribers.subscribe(topic, sock)
    end
  end
end
