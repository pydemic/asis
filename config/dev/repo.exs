import Config

config :asis, Asis.Repo,
  username: "asis",
  password: "asis",
  database: "asis_dev",
  hostname: System.get_env("ASIS__POSTGRES_HOSTNAME", "postgres"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
