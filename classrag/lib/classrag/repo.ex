defmodule Classrag.Repo do
  use Ecto.Repo,
    otp_app: :classrag,
    adapter: Ecto.Adapters.Postgres
end
