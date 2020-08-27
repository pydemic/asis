defmodule Asis.Contexts.Registries.MorbidityRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.MorbidityRegistry`.
  """

  alias Asis.Contexts.Registries.MorbidityRegistry
  alias Asis.Repo

  @spec create(map()) :: {:ok, %MorbidityRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %MorbidityRegistry{}
    |> MorbidityRegistry.changeset(attrs)
    |> Repo.insert()
  end
end
