defmodule Balenax.Http do
  @moduledoc """
   Responsible for managing HTTP requests to the balena API
  """

  alias Balenax.Config
require Logger
  @headers [
    {"Content-type", "application/x-www-form-urlencoded"},
    {"Accept", "application/json"}
  ]

  @default_api_url "https://api.balena-cloud.com/v5"

  @doc """
  Sends an HTTP request to the Balena API to get the device by id

  ## Options

    * `:timeout` - the timeout for the request (defaults to 5000ms)

  ## Example

    {:ok, %{
      "success" => success,
      "challenge_ts" => ts,
      "hostname" => host,
      "error-codes" => errors
    }} = Balenax.Http.get_device(%{
      secret: "secret",
      response: "response",
      remote_ip: "remote_ip"
    })
  """
  @spec get_device_by_uuid(timeout: integer) ::
          {:ok, map} | {:error, [atom]}
  def get_device_by_uuid(balena_uuid, options \\ []) do
    timeout = options[:timeout] || Config.get_env(:balenax, :timeout, 5000)
    url = Enum.join([Config.get_env(:balenax, :api_url, @default_api_url), "device"], "/")
    url = Enum.join([url, "?$filter=uuid%20eq%20'", balena_uuid, "'"], "")
    json = Application.get_env(:balenax, :json_library, Jason)
    headers = @headers ++ [{"Authorization", "Bearer " <> Config.get_env(:balenax, :api_key)}]

    result =
      with {:ok, response} <-
            HTTPoison.get(url, headers, timeout: timeout),
          {:ok, data} <- json.decode(response.body) do
        {:ok, data}
      end
Logger.debug inspect(result)
    case result do
      {:ok, data} -> {:ok, data}
      {:error, :invalid} -> {:error, [:invalid_api_response]}
      {:error, {:invalid, _reason}} -> {:error, [:invalid_api_response]}
      {:error, %{reason: reason}} -> {:error, [reason]}
      {:error, %Jason.DecodeError{data: reason, position: _position}} -> {:error, [reason]}
    end
  end
end
