defmodule Asis.Contexts.Registries.BirthRegistry do
  @moduledoc """
  A Brazilian SINASC birth registry.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Registries.BirthRegistry

  @primary_key {:id, :integer, autogenerate: false}
  schema "birth_registries" do
    field :year, :integer

    field :city_id, :integer
    field :home_city_id, :integer
  end

  @doc false
  @spec changeset(%BirthRegistry{}, map()) :: Ecto.Changeset.t()
  def changeset(birth_registry, attrs) do
    birth_registry
    |> cast(attrs, [:id, :year, :city_id, :home_city_id])
    |> validate_required([:id, :year, :city_id, :home_city_id])
    |> unique_constraint(:id)
  end
end
