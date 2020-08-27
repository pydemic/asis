defmodule Asis.Contexts.Geo.Continent do
  @moduledoc """
  A continent.

  It is expected to follow the seven-continent model.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Geo
  alias Asis.Contexts.Geo.Continent

  @primary_key {:id, :integer, autogenerate: false}
  schema "continents" do
    field :name, :string
    field :abbr, :string

    field :lat, :float
    field :lng, :float

    belongs_to :world, Geo.World

    has_many :countries, Geo.Country
    has_many :regions, Geo.Region
    has_many :states, Geo.State
    has_many :mesoregions, Geo.Mesoregion
    has_many :microregions, Geo.Microregion
    has_many :cities, Geo.City
  end

  @doc false
  @spec changeset(%Continent{}, map()) :: Ecto.Changeset.t()
  def changeset(continent, attrs) do
    continent
    |> cast(attrs, [:id, :name, :abbr, :lat, :lng, :world_id])
    |> validate_required([:id, :name, :abbr, :lat, :lng, :world_id])
  end
end
