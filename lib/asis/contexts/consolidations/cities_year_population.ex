defmodule Asis.Contexts.Consolidations.CitiesYearPopulation do
  @moduledoc """
  Manage `Asis.Contexts.Consolidations.CityYearPopulation`.
  """

  import Ecto.Query, only: [where: 3]
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

  @spec create(map()) :: {:ok, %CityYearPopulation{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %CityYearPopulation{}
    |> CityYearPopulation.changeset(attrs)
    |> Repo.insert()
  end

  @spec add(%CityYearPopulation{}, %CityYearPopulation{}) :: %CityYearPopulation{}
  def add(from, to) do
    fields = [
      :age_0_4,
      :age_5_9,
      :age_10_14,
      :age_15_19,
      :age_20_29,
      :age_30_39,
      :age_40_49,
      :age_50_59,
      :age_60_69,
      :age_70_79,
      :age_80_or_more,
      :female,
      :male,
      :total
    ]

    Enum.reduce(fields, to, &Map.update(&2, &1, 0, fn value -> value + Map.get(from, &1) end))
  end
end
