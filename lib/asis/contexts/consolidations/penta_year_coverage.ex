defmodule Asis.Contexts.Consolidations.PentaYearCoverage do
  @moduledoc """
  Yearly penta 3rd vaccine dose coverage from a city.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Consolidations.PentaYearCoverage
  alias Asis.Contexts.Geo

  schema "penta_year_coverages" do
    field :total, :integer, default: 0
    field :year, :integer, default: 0

    belongs_to :city, Geo.City
  end

  @doc false
  @spec changeset(%PentaYearCoverage{}, map()) :: Ecto.Changeset.t()
  def changeset(penta_year_coverage, attrs) do
    penta_year_coverage
    |> cast(attrs, [:total, :year, :city_id])
    |> validate_required([:total, :year, :city_id])
  end
end
