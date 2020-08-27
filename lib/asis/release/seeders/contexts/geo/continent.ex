defmodule Asis.Release.Seeders.Contexts.Geo.Continent do
  @moduledoc """
  Seed `Asis.Contexts.Geo.Continent` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/continents.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, world_id]) do
    {:ok, _continent} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        world_id: String.to_integer(world_id)
      }
      |> Geo.Continents.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
