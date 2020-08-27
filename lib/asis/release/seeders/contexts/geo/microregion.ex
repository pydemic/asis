defmodule Asis.Release.Seeders.Contexts.Geo.Microregion do
  @moduledoc """
  Seed `Asis.Contexts.Geo.Microregion` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/microregions.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, mesoregion_id]) do
    {:ok, _microregion} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        mesoregion_id: String.to_integer(mesoregion_id)
      }
      |> Geo.Microregions.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
