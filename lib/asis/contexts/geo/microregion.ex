defmodule Asis.Contexts.Geo.Microregion do
  @moduledoc """
  A microregion.

  If from Brazil, the `id` is expected to follow the 5-digit IBGE microregion code.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.Microregion

  @primary_key {:id, :integer, autogenerate: false}
  schema "microregions" do
    field :name, :string
    field :abbr, :string

    field :lat, :float
    field :lng, :float

    belongs_to :mesoregion, Geo.Mesoregion
    belongs_to :state, Geo.State
    belongs_to :region, Geo.Region
    belongs_to :country, Geo.Country
    belongs_to :continent, Geo.Continent
    belongs_to :world, Geo.World

    has_many :cities, Geo.City
  end

  @doc false
  @spec changeset(%Microregion{}, map()) :: Ecto.Changeset.t()
  def changeset(microregion, attrs) do
    microregion
    |> cast(attrs, cast_fields())
    |> validate_required([:id, :name, :abbr, :lat, :lng, :mesoregion_id])
    |> unique_constraint(:id)
    |> maybe_add_parents_of_parent()
  end

  defp cast_fields do
    [
      :id,
      :name,
      :abbr,
      :lat,
      :lng,
      :mesoregion_id,
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
        state_id: state_id,
        region_id: region_id,
        country_id: country_id,
        continent_id: continent_id,
        world_id: world_id
      } = Geo.Mesoregions.get!(changeset.changes.mesoregion_id)

      changeset
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
