defmodule Asis.Contexts.Registries.BirthRegistry do
  @moduledoc """
  A Brazilian SINASC birth registry.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Registries.BirthRegistry

  schema "birth_registries" do
    field :year, :integer

    # Source
    field :numerodn, :integer
    field :codmunnasc, :integer
    field :codmunres, :integer
  end

  @doc false
  @spec changeset(%BirthRegistry{}, map()) :: Ecto.Changeset.t()
  def changeset(birth_registry, attrs) do
    birth_registry
    |> cast(attrs, [:year, :numerodn, :codmunnasc, :codmunres])
    |> validate_required([:numerodn])
  end
end
