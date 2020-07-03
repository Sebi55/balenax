# Balenax

[![Hex.pm](https://img.shields.io/badge/Hex-v2.1.1-green.svg)](https://hexdocs.pm/balenax)

An Elixir wrapper package for the Balena API [Balena].

[Balena]: https://www.balena.io/docs/reference/api/overview/

### Important Notice
The package is in active development. It is a side project required for the [PlantGuru] project which relies on Balena. Only the API endpoints needed for the development of PlantGuru are in active development. Please feel free to extend or improve this package with PRs at any time. I am happy to merge all compatible PRs.

[PlantGuru]: https://github.com/Plant-Guru

## Installation

1. Add balenax to your `mix.exs` dependencies

```elixir
  defp deps do
    [
      {:balenax, "~> 0.0.1"},
    ]
  end
```

2. List `:balenax` as an application dependency

```elixir
  def application do
    [ extra_applications: [:balenax] ]
  end
```

3. Run `mix do deps.get, compile`

## Config

By default the API key is loaded via the `BALENA_API_KEY` environment variable.

```elixir
  config :balenax,
    api_key: {:system, "BALENA_API_KEY"}
```

### JSON Decoding

By default `balenax` will use `Jason` to decode JSON responses, this can be changed as such:

```elixir
  config :hcaptcha, :json_library, Poison
```

## Usage

### Device API

Balenax provides the `get_device/1` method. Below is an example using a Phoenix controller action:

```elixir
  def create(conn, params) do
    case Balenax.get_device(params["uuid"]) do
      {:ok, response} -> do_something
      {:error, errors} -> handle_error
    end
  end
```

`get_device` method sends a `GET` request to the balena API and returns 2 possible values:

`{:ok, %Hcaptcha.Response{challenge_ts: timestamp, hostname: host}}` -> The captcha is valid, see the [documentation](https://developers.google.com/hcaptcha/docs/verify#api-response) for more details.

`{:error, errors}` -> `errors` contains atomised versions of the errors returned by the API, See the [error documentation](https://developers.google.com/hcaptcha/docs/verify#error-code-reference) for more details. Errors caused by timeouts in HTTPoison or Jason encoding are also returned as atoms. If the hcaptcha request succeeds but the challenge is failed, a `:challenge_failed` error is returned.

`verify` method also accepts a keyword list as the third parameter with the following options:

Option                  | Action                                                 | Default
:---------------------- | :----------------------------------------------------- | :------------------------
`timeout`               | Time to wait before timeout                            | 5000 (ms)
`secret`                | Private key to send as a parameter of the API request  | Private key from the config file
`remote_ip`             | Optional. The user's IP address, used by hCaptcha     | no default


## Testing

In order to test your endpoints you should set the secret key to the following value in order to receive a positive result from all queries to the Hcaptcha engine.

```
config :hcaptcha,
  secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
```

Setting up tests without network access can be done also. When configured as such a positive or negative result can be generated locally.

```
config :hcaptcha,
  http_client: Hcaptcha.Http.MockClient,
  secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"


  {:ok, _details} = Hcaptcha.verify("valid_response")

  {:error, _details} = Hcaptcha.verify("invalid_response")

```

## Contributing

Check out [CONTRIBUTING.md](/CONTRIBUTING.md) if you want to help.

## License

[MIT License](http://www.opensource.org/licenses/MIT).
