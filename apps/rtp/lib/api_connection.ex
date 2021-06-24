defmodule ApiConnection do
  require Logger
  use GenServer

  @ip {127, 0, 0, 1}
  @port 4041

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def send_message(message) do
    GenServer.cast(__MODULE__, {:message, message})
  end


  @impl true
  def init(:ok) do
    case :gen_tcp.connect(@ip, @port, [:binary, active: false, reuseaddr: true]) do
      {:ok, socket} -> {:ok, socket}
      {:error, reason} -> disconnect(reason)
    end
  end

  def handle_info({:tcp_closed, _}, socket), do: {:stop, :normal, socket}
  def handle_info({:tcp_error, _}, socket), do: {:stop, :normal, socket}

  @impl true
  def handle_cast({:message, message}, socket) do
    IO.puts message
    :ok = :gen_tcp.send(socket, message)
    {:noreply, socket}
  end

  def disconnect(reason) do
    Logger.info "Disconnected: #{reason}"
    {:stop, :normal, %{}}
  end
end
