defmodule Asis.Release.Seeders.Contexts.Geo.State do
  @moduledoc """
  Seed `Asis.Contexts.Geo.State` data.
  """

  require Logger
  alias Asis.Contexts.Geo
  alias Asis.Release.Seeders.CSVSeeder

  @path "geo/states.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([id, name, abbr, lat, lng, region_id]) do
    {:ok, _state} =
      %{
        id: String.to_integer(id),
        name: name,
        abbr: abbr,
        lat: String.to_float(lat),
        lng: String.to_float(lng),
        region_id: String.to_integer(region_id)
      }
      |> Geo.States.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
