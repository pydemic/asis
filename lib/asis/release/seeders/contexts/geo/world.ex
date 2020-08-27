defmodule Asis.Release.Seeders.Contexts.Geo.World do
  @moduledoc """
  Seed `Asis.Contexts.Geo.World` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/worlds.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng]) do
    {:ok, _world} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng)
      }
      |> Geo.Worlds.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
