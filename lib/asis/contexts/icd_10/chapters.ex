defmodule Asis.Contexts.ICD10.Chapters do
  @moduledoc """
  Manage `Asis.Contexts.ICD10.Chapter`.
  """

  alias Asis.Contexts.ICD10.Chapter
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Chapter{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Chapter{}
    |> Chapter.changeset(attrs)
    |> Repo.insert()
  end
end
