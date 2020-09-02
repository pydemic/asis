defmodule Asis.Contexts.Consolidations.CitiesYearPopulationTest do
  use Asis.DataCase
  alias Asis.Contexts.Consolidations.{CitiesYearPopulation, CityYearPopulation}
  alias Asis.Contexts.Geo

  @moduletag :contexts

  describe "cities_year_population" do
    test "create/1 with valid data creates a city_year_population" do
      attrs = %{
        age_0_4: 10,
        age_5_9: 10,
        age_10_14: 10,
        age_15_19: 10,
        age_20_29: 10,
        age_30_39: 10,
        age_40_49: 10,
        age_50_59: 10,
        age_60_69: 10,
        age_70_79: 10,
        age_80_or_more: 10,
        female: 55,
        male: 55,
        total: 110,
        year: 2020,
        city_id: fetch_city_id()
      }

      assert {:ok, %CityYearPopulation{}} = CitiesYearPopulation.create(attrs)
    end
  end

  defp fetch_city_id do
    attrs = %{id: 1, name: "World", abbr: "W", lat: 0.0, lng: 0.0}
    {:ok, %{id: world_id}} = Geo.Worlds.create(attrs)

    attrs = %{id: 6, name: "South America", abbr: "SA", lat: -8.7832, lng: -55.4915, world_id: world_id}
    {:ok, %{id: continent_id}} = Geo.Continents.create(attrs)

    attrs = %{id: 76, name: "Brazil", abbr: "BR", lat: -14.2350, lng: -51.9253, continent_id: continent_id}
    {:ok, %{id: country_id}} = Geo.Countries.create(attrs)

    attrs = %{id: 1, name: "Norte", abbr: "N", lat: 2.0953, lng: -58.1317, country_id: country_id}
    {:ok, %{id: region_id}} = Geo.Regions.create(attrs)

    attrs = %{id: 14, name: "Roraima", abbr: "RR", lat: 2.7376, lng: -62.0751, region_id: region_id}
    {:ok, %{id: state_id}} = Geo.States.create(attrs)

    attrs = %{id: 1401, name: "Norte de Roraima", abbr: "NRR", lat: 0.0, lng: 0.0, state_id: state_id}
    {:ok, %{id: mesoregion_id}} = Geo.Mesoregions.create(attrs)

    attrs = %{id: 14_001, name: "Boa Vista", abbr: "Boa Vista", lat: 0.0, lng: 0.0, mesoregion_id: mesoregion_id}
    {:ok, %{id: microregion_id}} = Geo.Microregions.create(attrs)

    attrs = %{id: -1401, name: "Centro Norte de Roraima", abbr: "CNRR", lat: 0.0, lng: 0.0, state_id: state_id}
    {:ok, %{id: health_region_id}} = Geo.HealthRegions.create(attrs)

    attrs = %{
      id: 140_002,
      name: "Amajari",
      abbr: "Amajari",
      lat: 0.0,
      lng: 0.0,
      microregion_id: microregion_id,
      health_region_id: health_region_id
    }

    {:ok, %{id: city_id}} = Geo.Cities.create(attrs)

    city_id
  end
end
