defmodule GurgleServer.Authentication do
  def plain(id, password) do
    {username, domain} = PacketProcessor.ID.gurgle_id(id)
    if domain == Application.get_env(:gurgle_server, :domain, "example.org") do
      case DBPostgres.User.plain_auth(username, password) do
        {:ok, user} ->
          :ok
        _ -> {:error, :password, "Wrong password."}
      end
    else
      {:error, :password, "Wrong password."}
    end
  end
end
