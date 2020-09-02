defmodule Asis.Release.Seeders.Contexts.Geo do
  @moduledoc """
  Seed `Asis.Contexts.Geo` data.
  """

  alias Asis.Release.Seeders.Contexts.Geo

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    Geo.World.seed(opts)
    Geo.Continent.seed(opts)
    Geo.Country.seed(opts)
    Geo.Region.seed(opts)
    Geo.State.seed(opts)
    Geo.Mesoregion.seed(opts)
    Geo.Microregion.seed(opts)
    Geo.HealthRegion.seed(opts)
    Geo.City.seed(opts)
  end
end
