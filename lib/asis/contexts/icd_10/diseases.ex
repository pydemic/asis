defmodule Asis.Contexts.ICD10.Diseases do
  @moduledoc """
  Manage `Asis.Contexts.ICD10.Disease`.
  """

  alias Asis.Contexts.ICD10.Disease
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Disease{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Disease{}
    |> Disease.changeset(attrs)
    |> Repo.insert()
  end
end
