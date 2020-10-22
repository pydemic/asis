defmodule Asis.Contexts.Registries.DeathRegistry do
  @moduledoc """
  A Brazilian SIM death registry.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Registries.DeathRegistry

  @primary_key {:id, :integer, autogenerate: false}
  schema "death_registries" do
    field :year, :integer

    field :age, :integer

    field :city_id, :integer

    field :disease_id, :string
    field :sub_disease_id, :string
    field :chapter_id, :string
  end

  @doc false
  @spec changeset(%DeathRegistry{}, map()) :: Ecto.Changeset.t()
  def changeset(death_registry, attrs) do
    death_registry
    |> cast(attrs, [:id, :year, :age, :city_id, :disease_id, :sub_disease_id, :chapter_id])
    |> validate_required([:id, :year, :age, :city_id, :disease_id, :chapter_id])
    |> unique_constraint(:id)
  end
end
