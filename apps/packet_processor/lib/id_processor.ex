defmodule PacketProcessor.ID do
  def gurgle_id_str(id) do
    {username, domain} = gurgle_id(id)
    "#{username}@#{domain}"
  end

  def gurgle_id({username, nil}) do
    {username, Application.get_env(:gurgle_server, :domain, "example.org")}
  end

  def gurgle_id({username, domain}) do
    {username, domain}
  end

  def gurgle_id(gurgle_id) do
    result = case String.split(gurgle_id, "@", parts: 2) do
      [username] ->
        {username, nil}
      [username, domain] ->
        {username, domain}
    end
    gurgle_id(result)
  end
end
