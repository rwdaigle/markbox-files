use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :markbox_files, MarkboxFiles.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  cache_static_lookup: false,
  watchers: []

# Watch static and templates for browser reloading.
config :markbox_files, MarkboxFiles.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Configure your database
# config :markbox_files, MarkboxFiles.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "markbox_files_dev"
