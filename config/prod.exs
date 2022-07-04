import Config

config :sme_interviews, SmeInterviewsWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  load_from_system_env: true,
  http: [port: {:system, "PORT"}], # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  server: true, # Without this line, your app will not start the web server!
  secret_key_base: "${SECRET_KEY_BASE}",
  url: [host: "${APP_NAME}.gigalixirapp.com", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  version: Mix.Project.config[:version], # to bust cache during hot upgrades
  check_origin: ["//gigalixirapp.com"]

config :sme_interviews, SmeInterviews.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "${DATABASE_URL}",
  database: "",
  # ssl: true,
  pool_size: 2 # Free tier db only allows 4 connections. Rolling deploys need pool_size*(n+1) connections where n is the number of app replicas.

config :logger, level: :info

config :sme_interviews, SmeInterviews.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smeinterviews.com",
  username: "info@smeinterviews.com",
  password: "${SMTP_PASSWORD}",
  ssl: true,
  tls: :if_available,
  auth: :always,
  port: 465,
  retries: 2,
  no_mx_lookups: true
