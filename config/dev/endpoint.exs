import Config

config :asis, AsisWeb.Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  http: [port: 4000],
  https: [
    port: 4001,
    cipher_suite: :strong,
    certfile: Path.expand("../../priv/cert/selfsigned.pem", __DIR__),
    keyfile: Path.expand("../../priv/cert/selfsigned_key.pem", __DIR__)
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/asis_web/(live|views)/.*(ex)$",
      ~r"lib/asis_web/templates/.*(eex)$"
    ]
  ],
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../../assets", __DIR__)
    ]
  ]
