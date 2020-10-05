defmodule Asis.Contexts.Registries.MorbidityRegistry do
  @moduledoc """
  A Brazilian DATASUS morbidity registry.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Registries.MorbidityRegistry

  schema "morbidity_registries" do
    field :year, :integer
    field :week, :integer

    field :age, :integer

    field :city_id, :integer

    field :disease_id, :string
    field :sub_disease_id, :string
  end

  @doc false
  @spec changeset(%MorbidityRegistry{}, map()) :: Ecto.Changeset.t()
  def changeset(morbidity_registry, attrs) do
    morbidity_registry
    |> cast(attrs, [:year, :week, :age, :city_id, :disease_id, :sub_disease_id])
    |> validate_required([:year, :week, :age, :city_id, :disease_id])
  end
end
