defmodule Asis.Contexts.Registries.DeathRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.DeathRegistry`.
  """

  alias Asis.Contexts.Registries.DeathRegistry
  alias Asis.Repo

  @spec create(map()) :: {:ok, %DeathRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %DeathRegistry{}
    |> DeathRegistry.changeset(attrs)
    |> Repo.insert()
  end
end
