defmodule Asis.Release.Seeders.Contexts.Geo.Mesoregion do
  @moduledoc """
  Seed `Asis.Contexts.Geo.Mesoregion` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/mesoregions.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, state_id]) do
    {:ok, _mesoregion} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        state_id: String.to_integer(state_id)
      }
      |> Geo.Mesoregions.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
