defmodule ServerBusiness.Authentication do
  def plain(id, password) do
    {username, domain} = PacketProcessor.ID.gurgle_id(id)
    case {username, domain, password} do
      {"misaka4e21", "hitorino.moe", "123456"} ->
        :ok
      _ -> {:error, :password, "Wrong password."}
    end
  end

end
