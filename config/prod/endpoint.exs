import Config

config :asis, AsisWeb.Endpoint,
  cache_static_manifest: Path.expand("../../priv/static/cache_manifest.json", __DIR__),
  server: true
