defmodule Asis.Contexts.Registries.MorbidityRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.MorbidityRegistry`.
  """

  import Ecto.Query, only: [select: 3, where: 3]
  alias Asis.Contexts.Registries.MorbidityRegistry
  alias Asis.Repo

  @spec list_by_cities_and_period(list(integer()), map()) :: list(%MorbidityRegistry{})
  def list_by_cities_and_period(cities_ids, period) do
    MorbidityRegistry
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

  @spec list_by(keyword()) :: list(%MorbidityRegistry{})
  def list_by(params) do
    MorbidityRegistry
    |> filter_by_params(params)
    |> Repo.all()
  end

  @spec count_by(keyword()) :: integer()
  def count_by(params) do
    MorbidityRegistry
    |> filter_by_params(params)
    |> select([mr], count())
    |> Repo.one()
  end

  @spec create(map()) :: {:ok, %MorbidityRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %MorbidityRegistry{}
    |> MorbidityRegistry.changeset(attrs)
    |> Repo.insert()
  end

  defp filter_by_params(query, params) do
    if Enum.any?(params) do
      [param | params] = params

      case param do
        {:cities, cities} -> where(query, [mr], mr.city_id in ^cities)
        {:city, city} -> where(query, [mr], mr.city_id == ^city)
        {:diseases, diseases} -> where(query, [mr], mr.disease_id in ^diseases)
        {:sub_diseases, sub_diseases} -> where(query, [mr], mr.sub_disease_id in ^sub_diseases)
        {:sub_diseases_or_diseases, {s, d}} -> where(query, [mr], mr.sub_disease_id in ^s or mr.disease_id in ^d)
        {:week_from, from} -> where(query, [mr], mr.week >= ^from)
        {:week_to, to} -> where(query, [mr], mr.week <= ^to)
        {:year_from, from} -> where(query, [mr], mr.year >= ^from)
        {:year_to, to} -> where(query, [mr], mr.year <= ^to)
        {:year, year} -> where(query, [mr], mr.year == ^year)
        _unknown_param -> query
      end
      |> filter_by_params(params)
    else
      query
    end
  end
end
