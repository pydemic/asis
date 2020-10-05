defmodule Asis.Contexts.Registries.BirthRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.BirthRegistry`.
  """

  import Ecto.Query, only: [where: 3]
  alias Asis.Contexts.Registries.BirthRegistry
  alias Asis.Repo

  @spec list_by_cities_and_period(list(integer()), map()) :: list(%BirthRegistry{})
  def list_by_cities_and_period(cities_ids, period) do
    BirthRegistry
    |> where([br], br.city_id in ^cities_ids)
    |> maybe_filter_by_year_from(Map.get(period, :year_from))
    |> maybe_filter_by_year_to(Map.get(period, :year_to))
    |> Repo.all()
  end

  defp maybe_filter_by_year_from(query, nil), do: query
  defp maybe_filter_by_year_from(query, year_from), do: where(query, [br], br.year >= ^year_from)

  defp maybe_filter_by_year_to(query, nil), do: query
  defp maybe_filter_by_year_to(query, year_to), do: where(query, [br], br.year <= ^year_to)

  @spec create(map()) :: {:ok, %BirthRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %BirthRegistry{}
    |> BirthRegistry.changeset(attrs)
    |> Repo.insert()
  end
end
