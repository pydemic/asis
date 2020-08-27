defmodule Asis.Contexts.ICD10.Block do
  @moduledoc """
  An ICD-10 block.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.ICD10
  alias Asis.Contexts.ICD10.Block

  @primary_key {:id, :string, autogenerate: false}
  schema "blocks" do
    field :name, :string

    belongs_to :parent_block, ICD10.Block, type: :string
    belongs_to :chapter, ICD10.Chapter, type: :string

    has_many :children_blocks, ICD10.Block, foreign_key: :parent_block_id

    many_to_many :diseases, ICD10.Disease, join_through: "block_diseases"
  end

  @doc false
  @spec changeset(%Block{}, map()) :: Ecto.Changeset.t()
  def changeset(block, attrs) do
    block
    |> cast(attrs, [:id, :name, :chapter_id, :parent_block_id])
    |> validate_required([:id, :name, :chapter_id])
  end
end
