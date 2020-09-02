defmodule Asis.Contexts.Geo.City do
  @moduledoc """
  A city, province, or municipality.

  If from Brazil, the `id` is expected to follow the 6-digit or 7-digit IBGE municipality code.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Consolidations
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.City

  @primary_key {:id, :integer, autogenerate: false}
  schema "cities" do
    field :name, :string
    field :abbr, :string

    field :lat, :float
    field :lng, :float

    belongs_to :microregion, Geo.Microregion
    belongs_to :mesoregion, Geo.Mesoregion
    belongs_to :health_region, Geo.HealthRegion
    belongs_to :state, Geo.State
    belongs_to :region, Geo.Region
    belongs_to :country, Geo.Country
    belongs_to :continent, Geo.Continent
    belongs_to :world, Geo.World

    has_many :yearly_population, Consolidations.CityYearPopulation
  end

  @doc false
  @spec changeset(%City{}, map()) :: Ecto.Changeset.t()
  def changeset(city, attrs) do
    city
    |> cast(attrs, cast_fields())
    |> validate_required([:id, :name, :abbr, :lat, :lng, :microregion_id])
    |> maybe_add_parents_of_parent()
  end

  defp cast_fields do
    [
      :id,
      :name,
      :abbr,
      :lat,
      :lng,
      :microregion_id,
      :mesoregion_id,
      :health_region_id,
      :state_id,
      :region_id,
      :country_id,
      :continent_id,
      :world_id
    ]
  end

  defp maybe_add_parents_of_parent(changeset) do
    if changeset.valid? do
      %{
        mesoregion_id: mesoregion_id,
        state_id: state_id,
        region_id: region_id,
        country_id: country_id,
        continent_id: continent_id,
        world_id: world_id
      } = Geo.Microregions.get!(changeset.changes.microregion_id)

      changeset
      |> put_change(:mesoregion_id, mesoregion_id)
      |> put_change(:state_id, state_id)
      |> put_change(:region_id, region_id)
      |> put_change(:country_id, country_id)
      |> put_change(:continent_id, continent_id)
      |> put_change(:world_id, world_id)
    else
      changeset
    end
  end
end
