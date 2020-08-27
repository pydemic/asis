defmodule Asis.Contexts.Geo.World do
  @moduledoc """
  The global geographic entity.

  It is expected to be a singleton with id as `1`.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.World

  @primary_key {:id, :integer, autogenerate: false}
  schema "worlds" do
    field :abbr, :string
    field :lat, :float
    field :lng, :float
    field :name, :string

    has_many :continents, Geo.Continent
    has_many :countries, Geo.Country
    has_many :regions, Geo.Region
    has_many :states, Geo.State
    has_many :mesoregions, Geo.Mesoregion
    has_many :microregions, Geo.Microregion
    has_many :cities, Geo.City
  end

  @doc false
  @spec changeset(%World{}, map()) :: Ecto.Changeset.t()
  def changeset(world, attrs) do
    world
    |> cast(attrs, [:id, :name, :abbr, :lat, :lng])
    |> validate_required([:id, :name, :abbr, :lat, :lng])
  end
end
