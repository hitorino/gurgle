defmodule PacketProcessor.ID do
  def gurgle_id_str(id) do
    {username, domain} = gurgle_id(id)
    "#{username}@#{domain}"
  end

  def gurgle_id({username, domain}) do
    {username, domain}
  end

  def gurgle_id(gurgle_id) do
    [username, domain] = String.split(gurgle_id, "@", parts: 2)
    gurgle_id({username, domain})
  end
end
