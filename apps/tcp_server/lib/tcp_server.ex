defmodule TcpServer do
  require Logger

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: 4` - receives data following its length in four-bytes big-endian format
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: 4, active: :once, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = C2S.start_link(client)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(connection) do
    {result, client} = case read_packet(connection) do
      {:ok, data} ->
        PacketProcessor.process_raw_packet(connection, data)
      {:error, :timeout} ->
        :gen_tcp.close(connection |> Connection.socket())
        {:closed, nil}
      _ -> {:error, connection}
    end

    if result == :ok do
      serve(client)
    end
  end

  defp read_packet(connection) do
    :gen_tcp.recv(connection |> Connection.socket(), 0, Connection.timeout_milis)
  end

  defp write_packet(connection, data) do
    :gen_tcp.send(connection |> Connection.socket(), data)
  end
end
