defmodule Asis.Contexts.Registries.DeathRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.DeathRegistry`.
  """

  import Ecto.Query, only: [select: 3, where: 3]
  alias Asis.Contexts.Registries.DeathRegistry
  alias Asis.Repo

  @spec list_by_cities_and_year(list(integer()), integer()) :: list(%DeathRegistry{})
  def list_by_cities_and_year(cities_ids, year) do
    DeathRegistry
    |> where([cyp], cyp.city_id in ^cities_ids and cyp.year == ^year)
    |> Repo.all()
  end

  @spec list_by(keyword()) :: list(%DeathRegistry{})
  def list_by(params) do
    DeathRegistry
    |> filter_by_params(params)
    |> Repo.all()
  end

  @spec count_by(keyword()) :: integer()
  def count_by(params) do
    DeathRegistry
    |> filter_by_params(params)
    |> select([dr], count())
    |> Repo.one()
  end

  @spec create(map()) :: {:ok, %DeathRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %DeathRegistry{}
    |> DeathRegistry.changeset(attrs)
    |> Repo.insert()
  end

  defp filter_by_params(query, params) do
    if Enum.any?(params) do
      [param | params] = params

      case param do
        {:chapter, chapter} -> where(query, [dr], dr.chapter_id == ^chapter)
        {:cities, cities} -> where(query, [dr], dr.city_id in ^cities)
        {:city, city} -> where(query, [dr], dr.city_id == ^city)
        {:year, year} -> where(query, [dr], dr.year == ^year)
        _unknown_param -> query
      end
      |> filter_by_params(params)
    else
      query
    end
  end
end
