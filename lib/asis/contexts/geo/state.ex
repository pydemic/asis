defmodule Asis.Contexts.Geo.State do
  @moduledoc """
  A state or federal district.

  If from Brazil, the `id` is expected to follow the 2-digit IBGE state code.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.State

  @primary_key {:id, :integer, autogenerate: false}
  schema "states" do
    field :abbr, :string
    field :lat, :float
    field :lng, :float
    field :name, :string

    belongs_to :region, Geo.Region
    belongs_to :country, Geo.Country
    belongs_to :continent, Geo.Continent
    belongs_to :world, Geo.World

    has_many :mesoregions, Geo.Mesoregion
    has_many :microregions, Geo.Microregion
    has_many :heath_regions, Geo.HealthRegion
    has_many :cities, Geo.City
  end

  @doc false
  @spec changeset(%State{}, map()) :: Ecto.Changeset.t()
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:id, :abbr, :lat, :lng, :name, :region_id, :country_id, :continent_id, :world_id])
    |> validate_required([:id, :abbr, :lat, :lng, :name, :region_id])
    |> maybe_add_parents_of_parent()
  end

  defp maybe_add_parents_of_parent(changeset) do
    if changeset.valid? do
      %{country_id: country_id, continent_id: continent_id, world_id: world_id} =
        Geo.Regions.get!(changeset.changes.region_id)

      changeset
      |> put_change(:country_id, country_id)
      |> put_change(:continent_id, continent_id)
      |> put_change(:world_id, world_id)
    else
      changeset
    end
  end
end
