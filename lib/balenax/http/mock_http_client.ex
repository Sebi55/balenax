defmodule Balenax.Http.MockClient do
  @moduledoc """
    A mock HTTP client used for testing.
  """
  alias Balenax.Http

  # every other match is a pass through to the real client
  def get_device_by_uuid(balena_uuid, options) do
    send(self(), {:get_device, balena_uuid, options})
    Http.get_device_by_uuid(balena_uuid, options)
  end
end
