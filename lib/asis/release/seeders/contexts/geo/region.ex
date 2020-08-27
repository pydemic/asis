defmodule Asis.Release.Seeders.Contexts.Geo.Region do
  @moduledoc """
  Seed `Asis.Contexts.Geo.Region` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/regions.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, country_id]) do
    {:ok, _region} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        country_id: String.to_integer(country_id)
      }
      |> Geo.Regions.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
