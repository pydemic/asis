defmodule Asis.Repo do
  @moduledoc """
  Database integration and helper functions.
  """

  use Ecto.Repo,
    otp_app: :asis,
    adapter: Ecto.Adapters.Postgres
end
