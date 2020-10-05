defmodule Asis.Contexts.ICD10.Disease do
  @moduledoc """
  An ICD-10 disease.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.ICD10
  alias Asis.Contexts.ICD10.Disease

  @primary_key {:id, :string, autogenerate: false}
  schema "diseases" do
    field :name, :string

    has_many :sub_diseases, ICD10.SubDisease

    many_to_many :blocks, ICD10.Block, join_through: "block_diseases"
  end

  @doc false
  @spec changeset(%Disease{}, map()) :: Ecto.Changeset.t()
  def changeset(disease, attrs) do
    disease
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
    |> unique_constraint(:id)
  end
end
