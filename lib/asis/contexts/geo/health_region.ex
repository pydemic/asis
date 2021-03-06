defmodule Asis.Contexts.Geo.HealthRegion do
  @moduledoc """
  A group of cities defined by governmental health institutions.

  If from Brazil, the `id` is expected to follow the 4-digit IBGE mesoregion code.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.HealthRegion

  @primary_key {:id, :integer, autogenerate: false}
  schema "health_regions" do
    field :abbr, :string
    field :name, :string

    field :lat, :float
    field :lng, :float

    belongs_to :state, Geo.State
    belongs_to :region, Geo.Region
    belongs_to :country, Geo.Country
    belongs_to :continent, Geo.Continent
    belongs_to :world, Geo.World

    has_many :cities, Geo.City
  end

  @doc false
  @spec changeset(%HealthRegion{}, map()) :: Ecto.Changeset.t()
  def changeset(health_region, attrs) do
    health_region
    |> cast(attrs, [:id, :name, :abbr, :lat, :lng, :state_id, :region_id, :country_id, :continent_id, :world_id])
    |> validate_required([:id, :name, :abbr, :lat, :lng, :state_id])
    |> unique_constraint(:id)
    |> maybe_add_parents_of_parent()
  end

  defp maybe_add_parents_of_parent(changeset) do
    if changeset.valid? do
      %{region_id: region_id, country_id: country_id, continent_id: continent_id, world_id: world_id} =
        Geo.States.get!(changeset.changes.state_id)

      changeset
      |> put_change(:region_id, region_id)
      |> put_change(:country_id, country_id)
      |> put_change(:continent_id, continent_id)
      |> put_change(:world_id, world_id)
    else
      changeset
    end
  end
end
