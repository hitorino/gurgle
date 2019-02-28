defmodule DBPostgres.User do
  use Ecto.Schema
  require Ecto.Query

  schema "users" do
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
  end

  def plain_auth(username, password) do
    user = DBPostgres.User |> Ecto.Query.where(username: ^username)|> Ecto.Query.first |> DBPostgres.Repo.one
    IO.inspect user
    Comeonin.Bcrypt.check_pass(user, password)
  end
end
