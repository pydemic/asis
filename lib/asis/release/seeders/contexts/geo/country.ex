defmodule Asis.Release.Seeders.Contexts.Geo.Country do
  @moduledoc """
  Seed `Asis.Contexts.Geo.Country` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/countries.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, continent_id]) do
    {:ok, _country} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        continent_id: String.to_integer(continent_id)
      }
      |> Geo.Countries.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
