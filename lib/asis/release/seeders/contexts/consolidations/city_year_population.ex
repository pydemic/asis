defmodule Asis.Release.Seeders.Contexts.Consolidations.CityYearPopulation do
  @moduledoc """
  Seed `Asis.Contexts.Consolidations.CityYearPopulation` data.
  """

  require Logger
  alias Asis.Contexts.Consolidations.CitiesYearPopulation
  alias Asis.Release.Seeders.CSVSeeder

  @path "consolidations/br/rr/cities_year_population"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(Path.join(@path, "2018.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2019.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2020.csv"), &parse_and_seed/1, opts)
  end

  @fields [
    :year,
    :city_id,
    :male,
    :female,
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
    :total
  ]

  defp parse_and_seed(values) do
    {:ok, _city_year_population} =
      @fields
      |> Enum.zip(Enum.map(values, &String.to_integer/1))
      |> Map.new()
      |> CitiesYearPopulation.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
