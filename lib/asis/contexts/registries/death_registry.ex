defmodule Asis.Contexts.Registries.DeathRegistry do
  @moduledoc """
  A Brazilian SIM death registry.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Registries.DeathRegistry

  schema "death_registries" do
    field :disease_id, :string
    field :sub_disease_id, :string
    field :year, :integer

    # Source
    field :numerodo, :integer
    field :idade, :integer
    field :codmunres, :integer
    field :causabas_o, :string
  end

  @doc false
  @spec changeset(%DeathRegistry{}, map()) :: Ecto.Changeset.t()
  def changeset(death_registry, attrs) do
    death_registry
    |> cast(attrs, [:disease_id, :sub_disease_id, :year, :numerodo, :idade, :codmunres, :causabas_o])
    |> validate_required([:numerodo])
  end
end
