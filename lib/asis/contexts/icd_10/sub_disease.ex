defmodule Asis.Contexts.ICD10.SubDisease do
  @moduledoc """
  An ICD-10 sub-disease.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.ICD10
  alias Asis.Contexts.ICD10.SubDisease

  @primary_key {:id, :string, autogenerate: false}
  schema "sub_diseases" do
    field :name, :string

    belongs_to :disease, ICD10.Disease, type: :string
  end

  @doc false
  @spec changeset(%SubDisease{}, map()) :: Ecto.Changeset.t()
  def changeset(sub_disease, attrs) do
    sub_disease
    |> cast(attrs, [:id, :name, :disease_id])
    |> validate_required([:id, :name, :disease_id])
  end
end
