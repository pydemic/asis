import Config

config :asis, Asis.Repo,
  username: "asis",
  password: "asis",
  database: "asis_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("ASIS__POSTGRES_HOSTNAME", "postgres"),
  pool: Ecto.Adapters.SQL.Sandbox
