defmodule Asis.Contexts.Geo.Region do
  @moduledoc """
  A country region.

  If from Brazil, the `id` is expected to to follow the single digit IBGE region code.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.Region

  @primary_key {:id, :integer, autogenerate: false}
  schema "regions" do
    field :name, :string
    field :abbr, :string

    field :lat, :float
    field :lng, :float

    belongs_to :country, Geo.Country
    belongs_to :continent, Geo.Continent
    belongs_to :world, Geo.World

    has_many :states, Geo.State
    has_many :mesoregions, Geo.Mesoregion
    has_many :microregions, Geo.Microregion
    has_many :cities, Geo.City
  end

  @doc false
  @spec changeset(%Region{}, map()) :: Ecto.Changeset.t()
  def changeset(region, attrs) do
    region
    |> cast(attrs, [:id, :name, :abbr, :lat, :lng, :country_id, :continent_id, :world_id])
    |> validate_required([:id, :name, :abbr, :lat, :lng, :country_id])
    |> maybe_add_parents_of_parent()
  end

  defp maybe_add_parents_of_parent(changeset) do
    if changeset.valid? do
      %{continent_id: continent_id, world_id: world_id} = Geo.Countries.get!(changeset.changes.country_id)

      changeset
      |> put_change(:continent_id, continent_id)
      |> put_change(:world_id, world_id)
    else
      changeset
    end
  end
end
