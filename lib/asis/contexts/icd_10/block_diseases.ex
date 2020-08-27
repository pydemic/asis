defmodule Asis.Contexts.ICD10.BlockDiseases do
  @moduledoc """
  Manage `Asis.Contexts.ICD10.BlockDisease`.
  """

  alias Asis.Contexts.ICD10.BlockDisease
  alias Asis.Repo

  @spec create(map()) :: {:ok, %BlockDisease{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %BlockDisease{}
    |> BlockDisease.changeset(attrs)
    |> Repo.insert()
  end
end
