defmodule Asis.Contexts.Registries.BirthRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.BirthRegistry`.
  """

  alias Asis.Contexts.Registries.BirthRegistry
  alias Asis.Repo

  @spec create(map()) :: {:ok, %BirthRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %BirthRegistry{}
    |> BirthRegistry.changeset(attrs)
    |> Repo.insert()
  end
end
