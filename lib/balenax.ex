defmodule Balenax do
  @moduledoc """
    A wrapper module for the balena API.

    for more details.
  """

  alias Balenax.{Http}

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

    case device do
      {:error, errors} ->
        {:error, errors}
      {:ok, %{"d" => []}} ->
        {:error, %{error: "No device found"}}
      {:ok, data} ->
        {:ok, data}
    end
  end

  def get_device_by_id(balena_uuid, options \\ []) do
    device =
      @http_client.get_device_by_id(
        balena_uuid,
        Keyword.take(options, [:timeout])
      )

    case device do
      {:error, errors} ->
        {:error, errors}
      {:ok, %{"d" => []}} ->
        {:error, %{error: "No device found"}}
      {:ok, data} ->
        {:ok, data}
    end
  end

  def create_device_env_variable(body, options \\ []) do
    device =
      @http_client.create_device_env_variable(
        request_body(body),
        Keyword.take(options, [:timeout])
      )

    case device do
      {:error, errors} ->
        {:error, errors}
      {:ok, %{"d" => []}} ->
        {:error, %{error: "No device found"}}
      {:ok, "Unique key constraint violated"} ->
        {:error, %{error: "Unique key constraint violated"}}
      {:ok, data} ->
        {:ok, data}
    end
  end

  defp request_body(body) do
    body
    |> URI.encode_query()
  end

end
