defmodule Asis.Contexts.Registries.MorbidityRegistry do
  @moduledoc """
  A Brazilian DATASUS morbidity registry.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Registries.MorbidityRegistry

  schema "morbidity_registries" do
    field :disease_id, :string
    field :sub_disease_id, :string
    field :year, :integer

    # Source
    field :nu_notific, :integer
    field :id_agravo, :string
    field :id_municip, :integer
    field :nu_idade_n, :integer
  end

  @doc false
  @spec changeset(%MorbidityRegistry{}, map()) :: Ecto.Changeset.t()
  def changeset(morbidity_registry, attrs) do
    morbidity_registry
    |> cast(attrs, [:disease_id, :sub_disease_id, :year, :nu_notific, :id_agravo, :id_municip, :nu_idade_n])
    |> validate_required([:nu_notific])
  end
end
