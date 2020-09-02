defmodule Asis.Release.Seeders.Contexts.Geo.City do
  @moduledoc """
  Seed `Asis.Contexts.Geo.City` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/cities.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, microregion_id, health_region_id]) do
    {:ok, _city} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        microregion_id: String.to_integer(microregion_id),
        health_region_id: String.to_integer(health_region_id)
      }
      |> Geo.Cities.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
