defmodule C2S do
  use GenServer

  ## Client API
  def start_link(socket) do
    GenServer.start_link(__MODULE__, %Connection{socket: socket}, name: __MODULE__)
  end

  def forward(server, packet_obj) do
    GenServer.call(server, {:forward_message, packet_obj})
  end

  def update_connection(server, connection) do
    GenServer.cast(server, {:update_connection, connection})
  end

  ## Server Callbacks

  def init(connection) do
    {:ok, connection}
  end

  def handle_cast({:update_connection, connection}, _from, _connection) do
    {:noreply, connection}
  end

  def handle_call({:forward_message, packet_obj}, _from, connection) do
    case ServerBusiness.send_packet(connection, packet_obj) do
      {:ok, connection} -> {:reply, :ok, connection}
      {:error, reason} -> {:reply, reason, connection}
    end
  end

  def handle_info({:tcp, socket, packet_data}, connection) do
    connection = %Connection{connection | socket: socket, ping: :os.system_time(:seconds)}

    case PacketProcessor.process_raw_packet(connection, packet_data) do
      {:ok, connection} ->
        :inet.setopts(connection |> Connection.socket(), active: :once)
        {:noreply, connection}
      _ ->
        :inet.setopts(connection |> Connection.socket(), active: :once)
        {:noreply, connection}
    end
  end

  def handle_info({:tcp_closed, socket}, connection) do
    IO.inspect("Socket has been closed")
    {:stop, :normal, connection}
  end

  def handle_info({:tcp_error, socket, reason}, connection) do
    IO.inspect(socket, label: "connection closed dut to #{reason}")
    {:stop, :normal, connection}
  end
end
