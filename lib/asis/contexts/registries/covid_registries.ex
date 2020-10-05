defmodule Asis.Contexts.Registries.CovidRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.CovidRegistry`.
  """

  import Ecto.Query, only: [where: 3]
  alias Asis.Contexts.Registries.CovidRegistry
  alias Asis.Repo

  @spec list_by_cities_and_period(list(integer()), map()) :: list(%CovidRegistry{})
  def list_by_cities_and_period(cities_ids, period) do
    CovidRegistry
    |> where([br], br.city_id in ^cities_ids)
    |> maybe_filter_by_year_from(Map.get(period, :year_from))
    |> maybe_filter_by_year_to(Map.get(period, :year_to))
    |> maybe_filter_by_week_from(Map.get(period, :week_from))
    |> maybe_filter_by_week_to(Map.get(period, :week_to))
    |> Repo.all()
  end

  defp maybe_filter_by_year_from(query, nil), do: query
  defp maybe_filter_by_year_from(query, year_from), do: where(query, [br], br.year >= ^year_from)
  defp maybe_filter_by_year_to(query, nil), do: query
  defp maybe_filter_by_year_to(query, year_to), do: where(query, [br], br.year <= ^year_to)

  defp maybe_filter_by_week_from(query, nil), do: query
  defp maybe_filter_by_week_from(query, week_from), do: where(query, [br], br.week >= ^week_from)
  defp maybe_filter_by_week_to(query, nil), do: query
  defp maybe_filter_by_week_to(query, week_to), do: where(query, [br], br.week <= ^week_to)

  @spec create(map()) :: {:ok, %CovidRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %CovidRegistry{}
    |> CovidRegistry.changeset(attrs)
    |> Repo.insert()
  end
end
