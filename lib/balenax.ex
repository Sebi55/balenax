defmodule Balenax do
  @moduledoc """
    A wrapper module for the balena API.

    for more details.
  """

  alias Balenax.{Config, Http}
require Logger
  @http_client Application.get_env(:balenax, :http_client, Http)

  @doc """
  Verifies a Balenax response string.

  ## Options

    * `:timeout` - the timeout for the request (defaults to 5000ms)
    * `:api_key`  - the secret key used by balena (defaults to the secret
      provided in application config)

  ## Example

    {:ok, api_response} = Balenax.get_device("uuid")
  """
  def get_device_by_uuid(balena_uuid, options \\ []) do
    device =
      @http_client.get_device_by_uuid(
        balena_uuid,
        Keyword.take(options, [:timeout])
      )
    Logger.debug inspect(device)
    case device do
      {:error, errors} ->
        {:error, errors}

      {:ok, %{"success" => false, "error-codes" => errors}} ->
        {:error, Enum.map(errors, &atomise_api_error/1)}

      {:ok,
       %{"success" => true, "challenge_ts" => timestamp, "hostname" => host}} ->
        {:ok, %{challenge_ts: timestamp, hostname: host}}

      {:ok,
       %{"success" => false, "challenge_ts" => _timestamp, "hostname" => _host}} ->
        {:error, [:challenge_failed]}
    end
  end

  # defp request_body(response, options) do
  #   body_options = Keyword.take(options, [:remote_ip, :secret])
  #   application_options = [secret: Config.get_env(:balenax, :secret)]

  #   # override application secret with options secret if it exists
  #   application_options
  #   |> Keyword.merge(body_options)
  #   |> Keyword.put(:response, response)
  #   |> URI.encode_query()
  # end

  defp atomise_api_error(error) do
    error
    |> String.replace("-", "_")
    |> String.to_atom()
  end
end
