defmodule PacketProcessor do
  require Logger
  alias Gurgle.Connection
  @moduledoc """
  Documentation for PacketProcessor.
  """

  def process_packet(client, packet_obj) do
    GurgleServer.dispatch(client, packet_obj)
  end

  def process_raw_packet(client, data) do
    case Jason.decode(data) do
      {:ok, obj} -> process_packet(client, obj)
      _ -> {:error, client}
    end
  end

  def send_packet(client, packet_obj) do
    case Jason.encode(packet_obj) do
      {:ok, data} -> Connection.send_packet_data(client, data)
      _ -> nil
    end
  end
end
