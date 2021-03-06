# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :markbox_files, MarkboxFiles.Endpoint,
  url: [host: "localhost"],
  root: Path.expand("..", __DIR__),
  secret_key_base: "O3dYA3bOHhqb/DulQex2xmLjnJQ1HE7VjExZ/nH9LV5G4msqvZW2FoF+4k5Mzh77",
  debug_errors: false,
  pubsub: [name: MarkboxFiles.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$message\n",
  metadata: [:request_id],
  level: :debug

config :markbox_files, MarkboxFiles.Endpoint, secret_key_base: System.get_env("APP_SECRET") ||
  "9vmQzrby45mWCSnGNXK/c8xPbP0Im64b9sb57cwyD6sP+SffuYN4thUwrzmIpn9/"

config :default, domain: System.get_env("APP_DEFAULT_DOMAIN") || "ryandaigle.com"
config :default, domain_aliases: ["localhost"]

config :dropbox, file_host: System.get_env("DROPBOX_FILE_HOST") || "https://content.dropboxapi.com"
config :dropbox, file_base: System.get_env("DROPBOX_FILE_BASE") || "/2/files/download"
config :dropbox, file_timeout: System.get_env("DROPBOX_FILE_TIMEOUT") || "20000"

config :markbox_auth, access_token: System.get_env("MARKBOX_AUTH_ACCESS_TOKEN") || "access-token"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
