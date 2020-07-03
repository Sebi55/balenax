use Mix.Config

config :balenax,
  http_client: Balenax.Http.MockClient,
  secret: "test_secret",
  public_key: "test_public_key"
