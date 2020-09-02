defmodule Asis.Contexts.Geo.Country do
  @moduledoc """
  A country.

  The `id` is expected to be the numeric code from ISO 3166, as integer.

  The `abbr` is expected to be the Alpha-2 code from ISO 3166.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.Country

  @primary_key {:id, :integer, autogenerate: false}
  schema "countries" do
    field :name, :string
    field :abbr, :string

    field :lat, :float
    field :lng, :float

    belongs_to :continent, Geo.Continent
    belongs_to :world, Geo.World

    has_many :regions, Geo.Region
    has_many :states, Geo.State
    has_many :mesoregions, Geo.Mesoregion
    has_many :microregions, Geo.Microregion
    has_many :health_regions, Geo.HealthRegion
    has_many :cities, Geo.City
  end

  @doc false
  @spec changeset(%Country{}, map()) :: Ecto.Changeset.t()
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:id, :name, :abbr, :lat, :lng, :continent_id, :world_id])
    |> validate_required([:id, :name, :abbr, :lat, :lng, :continent_id])
    |> maybe_add_parent_of_parent()
  end

  defp maybe_add_parent_of_parent(changeset) do
    if changeset.valid? do
      %{world_id: world_id} = Geo.Continents.get!(changeset.changes.continent_id)

      put_change(changeset, :world_id, world_id)
    else
      changeset
    end
  end
end
