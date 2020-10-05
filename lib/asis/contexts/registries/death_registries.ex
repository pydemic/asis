defmodule Asis.Contexts.Registries.DeathRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.DeathRegistry`.
  """

  import Ecto.Query, only: [where: 3]
  alias Asis.Contexts.Registries.DeathRegistry
  alias Asis.Repo

  @spec list_by_cities_and_year(list(integer()), integer()) :: list(%DeathRegistry{})
  def list_by_cities_and_year(cities_ids, year) do
    DeathRegistry
    |> where([cyp], cyp.city_id in ^cities_ids and cyp.year == ^year)
    |> Repo.all()
  end

  @spec create(map()) :: {:ok, %DeathRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %DeathRegistry{}
    |> DeathRegistry.changeset(attrs)
    |> Repo.insert()
  end
end
