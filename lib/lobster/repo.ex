defmodule Lobster.Repo do
  use Ecto.Repo,
    otp_app: :lobster,
    adapter: Ecto.Adapters.Postgres
end
