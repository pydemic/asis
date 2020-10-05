defmodule Asis.Contexts.Consolidations.CityYearPopulation do
  @moduledoc """
  Yearly demographic data from a city.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Consolidations.CityYearPopulation
  alias Asis.Contexts.Geo

  schema "cities_year_population" do
    field :age_0_4, :integer, default: 0
    field :age_5_9, :integer, default: 0
    field :age_10_14, :integer, default: 0
    field :age_15_19, :integer, default: 0
    field :age_20_29, :integer, default: 0
    field :age_30_39, :integer, default: 0
    field :age_40_49, :integer, default: 0
    field :age_50_59, :integer, default: 0
    field :age_60_69, :integer, default: 0
    field :age_70_79, :integer, default: 0
    field :age_80_or_more, :integer, default: 0

    field :female, :integer, default: 0
    field :male, :integer, default: 0

    field :total, :integer, default: 0

    field :year, :integer, default: 0

    belongs_to :city, Geo.City
  end

  @doc false
  @spec changeset(%CityYearPopulation{}, map()) :: Ecto.Changeset.t()
  def changeset(city_year_population, attrs) do
    city_year_population
    |> cast(attrs, cast_fields())
    |> validate_required([:total, :year, :city_id])
  end

  defp cast_fields do
    [
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
      :total,
      :year,
      :city_id
    ]
  end
end
