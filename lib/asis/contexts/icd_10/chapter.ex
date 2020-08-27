defmodule Asis.Contexts.ICD10.Chapter do
  @moduledoc """
  An ICD-10 chapter.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Asis.Contexts.ICD10
  alias Asis.Contexts.ICD10.Chapter

  @primary_key {:id, :string, autogenerate: false}
  schema "chapters" do
    field :code_end, :string
    field :code_start, :string
    field :name, :string

    has_many :blocks, ICD10.Block
  end

  @doc false
  @spec changeset(%Chapter{}, map()) :: Ecto.Changeset.t()
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:id, :name, :code_start, :code_end])
    |> validate_required([:id, :name, :code_start, :code_end])
  end
end
