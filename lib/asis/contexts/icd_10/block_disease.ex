defmodule Asis.Contexts.ICD10.BlockDisease do
  @moduledoc """
  A relationship between `Asis.Contexts.ICD10.Block` and `Asis.Contexts.ICD10.Disease`.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.ICD10
  alias Asis.Contexts.ICD10.BlockDisease

  schema "block_diseases" do
    belongs_to :block, ICD10.Block, type: :string
    belongs_to :disease, ICD10.Disease, type: :string
  end

  @doc false
  @spec changeset(%BlockDisease{}, map()) :: Ecto.Changeset.t()
  def changeset(block_disease, attrs) do
    block_disease
    |> cast(attrs, [:block_id, :disease_id])
    |> validate_required([:block_id, :disease_id])
  end
end
