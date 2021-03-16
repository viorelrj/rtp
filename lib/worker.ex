defmodule Worker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle(server, data) do
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
    IO.puts Analysis.get_score(message)
    # Connection.handle_message(Connection, message)
  end

  defp handle_error() do
    {:error}
  end
end
