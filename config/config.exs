use Mix.Config

config :balenax,
  api_url: "https://api.balena-cloud.com/v5",
  api_key: {:system, "BALENA_API_KEY"}
  timeout: 5000

config :balenax, :json_library, Jason

import_config "#{Mix.env()}.exs"
