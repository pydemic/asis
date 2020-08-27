defmodule Asis.Contexts.ICD10.SubDiseases do
  @moduledoc """
  Manage `Asis.Contexts.ICD10.SubDisease`.
  """

  alias Asis.Contexts.ICD10.SubDisease
  alias Asis.Repo

  @spec create(map()) :: {:ok, %SubDisease{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %SubDisease{}
    |> SubDisease.changeset(attrs)
    |> Repo.insert()
  end
end
