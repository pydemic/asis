defmodule AsisWeb.RoraimaLive.DataManager.DemographicData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` demographic data.
  """

  alias Asis.Contexts.Consolidations.CitiesYearPopulation

  @spec fetch(map()) :: {map() | nil, map() | nil}
  def fetch(%{params: %{year_to: year, cities_ids: cities_ids, city_options: cities}}) do
    cities_year_population = CitiesYearPopulation.list_by(cities: Enum.map(cities, & &1.id))
    selected_cities_population = Enum.filter(cities_year_population, &(&1.city_id in cities_ids))

    {population_2018, population_2019, population_2020} =
      Enum.reduce(selected_cities_population, {0, 0, 0}, &count_population/2)

    cities_population =
      cities
      |> Enum.reduce({[], Enum.filter(cities_year_population, &(&1.year == year))}, &count_city_population/2)
      |> elem(0)
      |> Enum.reverse()

    local_population =
      case year do
        2018 -> population_2018
        2019 -> population_2019
        2020 -> population_2020
      end

    {%{local_population: local_population},
     %{
       local_population: local_population,
       yearly_population: [population_2018, population_2019, population_2020],
       cities_population: cities_population
     }}
  end

  defp count_population(%{year: 2018, total: total}, {p2018, p2019, p2020}), do: {p2018 + total, p2019, p2020}
  defp count_population(%{year: 2019, total: total}, {p2018, p2019, p2020}), do: {p2018, p2019 + total, p2020}
  defp count_population(%{year: 2020, total: total}, {p2018, p2019, p2020}), do: {p2018, p2019, p2020 + total}
  defp count_population(_city_year_population, yearly_population), do: yearly_population

  defp count_city_population(%{id: id}, {cities_population, cities_year_population}) do
    {city_population, cities_year_population} = Enum.split_with(cities_year_population, &(&1.city_id == id))
    {[Enum.reduce(city_population, 0, &(&2 + &1.total))] ++ cities_population, cities_year_population}
  end
end
