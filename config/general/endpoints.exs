import Config

config :asis, AsisWeb.Endpoint,
  live_view: [signing_salt: "cWHQs4V9"],
  pubsub_server: Asis.PubSub,
  url: [host: "localhost"],
  render_errors: [view: AsisWeb.ErrorView, accepts: ~w(html json), layout: false],
  secret_key_base: "Cd6TFymxTTCv5s3N96AbHsZr7g2TvpRVsM+uG9La9OfNQNaF4yaMhSTmiOBPxmmr"
