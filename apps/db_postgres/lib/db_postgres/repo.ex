defmodule DBPostgres.Repo do
  use Ecto.Repo,
    otp_app: :db_postgres,
    adapter: Ecto.Adapters.Postgres
end
