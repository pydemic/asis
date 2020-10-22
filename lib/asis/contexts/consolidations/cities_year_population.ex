defmodule Asis.Contexts.Consolidations.CitiesYearPopulation do
  @moduledoc """
  Manage `Asis.Contexts.Consolidations.CityYearPopulation`.
  """

  import Ecto.Query, only: [select: 3, where: 3]
  alias Asis.Contexts.Consolidations.CityYearPopulation
  alias Asis.Repo

  @spec get_by_city_and_year(integer(), integer()) :: %CityYearPopulation{} | nil
  def get_by_city_and_year(city_id, year) do
    CityYearPopulation
    |> Repo.get_by(city_id: city_id, year: year)
  end

  @spec list_by_cities_and_year(list(integer()), integer()) :: %CityYearPopulation{}
  def list_by_cities_and_year(cities_ids, year) do
    CityYearPopulation
    |> where([cyp], cyp.city_id in ^cities_ids and cyp.year == ^year)
    |> Repo.all()
  end

  @spec list_by(keyword()) :: list(%CityYearPopulation{})
  def list_by(params) do
    CityYearPopulation
    |> filter_by_params(params)
    |> Repo.all()
  end

  @spec sum_by(atom(), keyword()) :: integer()
  def sum_by(field, params) do
    CityYearPopulation
    |> filter_by_params(params)
    |> select([cyp], sum(field(cyp, ^field)))
    |> Repo.one()
  end

  @spec create(map()) :: {:ok, %CityYearPopulation{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %CityYearPopulation{}
    |> CityYearPopulation.changeset(attrs)
    |> Repo.insert()
  end

  defp filter_by_params(query, params) do
    if Enum.any?(params) do
      [param | params] = params

      case param do
        {:cities, cities} -> where(query, [cyp], cyp.city_id in ^cities)
        {:year, year} -> where(query, [cyp], cyp.year == ^year)
        _unknown_param -> query
      end
      |> filter_by_params(params)
    else
      query
    end
  end
end
