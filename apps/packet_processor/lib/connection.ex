defmodule Gurgle.Connection do
  alias Gurgle.Connection
  @timeout_secs 4*60

  def timeout_milis do
    @timeout_secs * 1000
  end

  defstruct socket: nil,
            state: :initial,
            authed: false,
            username: "",
            ping: :os.system_time(:seconds)

  def socket(%Connection{socket: socket}) do
    socket
  end

  def authed?(connection = %Connection{authed: authed}) do
    if authed do
      {:ok, connection}
    else
      {:error, connection, :unauthed}
    end
  end

  def send_packet_data(connection = %Connection{socket: socket}, data) do
    case :gen_tcp.send(socket, data) do
      :ok -> {:ok, connection}
      {:error, reason} -> {:error, reason}
    end
  end

  def close(connection = %Connection{socket: socket}) do
    :gen_tcp.close(socket)
    {:closed}
  end
end
