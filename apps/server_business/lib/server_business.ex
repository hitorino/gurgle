defmodule ServerBusiness do
  @moduledoc """
  Documentation for ServerBusiness.
  """

  @doc """
  Respond to client version handshake.
  """
  def dispatch(client = %Connection{state: :initial}, %{"id" => id, "version" => version}) do
    client = %Connection{client | state: :unauthed}
    send_packet(client, %{
      "id" => id,
      "version" => "0.2"
    })
  end

  @doc """
  Respond to client auth method query.
  """
  def dispatch(client = %Connection{state: :unauthed}, %{"id" => id, "cmd" => "query", "params" => %{"query" => "auth"}}) do
    send_packet(client, %{
      "id" => id,
      "params" => %{
        "answer" => ["plain"]
      }
    })
  end

  @doc """
  Do authentication
  """
  def dispatch(client = %Connection{authed: false, state: :unauthed}, %{
    "id" => id,
    "cmd" => "auth",
    "from" => gurgle_id,
    "params" => %{
      "method" => "plain",
      "password" => password
      }
  }) do
    case ServerBusiness.Authentication.plain(gurgle_id, password) do
      :ok ->
        {username, _} = PacketProcessor.ID.gurgle_id(gurgle_id)
        client = %Connection{ client | authed: true, state: :authed, username: username}
        send_packet(client, %{
          "id" => id,
          "to" => PacketProcessor.ID.gurgle_id_str(gurgle_id),
          "error" => nil
        })
      {:error, type, reason} ->
        send_packet(client, %{
          "id" => id,
          "to" => PacketProcessor.ID.gurgle_id_str(gurgle_id),
          "error" => Atom.to_string(type),
          "reason" => reason
        })
        Connection.close client
    end
  end

  @doc """
  Respond to client ping.
  """
  def dispatch(client = %Connection{authed: true}, %{"id" => id, "cmd" => "ping"}) do
    send_packet(client, %{
      "id" => id,
      "cmd" => "pong"
    })
  end

  @doc "Catch-all function to ignore invalid packets"
  def dispatch(client, packet) do
    {:ok, client}
  end

  def send_packet(connection, packet) do
    PacketProcessor.send_packet(connection, packet)
  end
end
