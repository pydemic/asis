defmodule Asis.Release.Seeders.Contexts.Geo.HealthRegion do
  @moduledoc """
  Seed `Asis.Contexts.Geo.HealthRegion` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/health_regions.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, state_id]) do
    {:ok, _health_region} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        state_id: String.to_integer(state_id)
      }
      |> Geo.HealthRegions.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
