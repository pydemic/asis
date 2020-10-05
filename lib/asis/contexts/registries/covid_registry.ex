defmodule Asis.Contexts.Registries.CovidRegistry do
  @moduledoc """
  A Brazilian DATASUS covid registry.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.Registries.CovidRegistry

  @primary_key {:id, :string, autogenerate: false}
  schema "covid_registries" do
    field :date, :date
    field :is_positive, :boolean

    field :city_id, :integer
  end

  @doc false
  @spec changeset(%CovidRegistry{}, map()) :: Ecto.Changeset.t()
  def changeset(covid_registry, attrs) do
    covid_registry
    |> cast(attrs, [:id, :date, :is_positive, :city_id])
    |> validate_required([:id, :date, :is_positive, :city_id])
  end
end
