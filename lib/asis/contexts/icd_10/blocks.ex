defmodule Asis.Contexts.ICD10.Blocks do
  @moduledoc """
  Manage `Asis.Contexts.ICD10.Block`.
  """

  alias Asis.Contexts.ICD10.Block
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Block{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Block{}
    |> Block.changeset(attrs)
    |> Repo.insert()
  end
end
