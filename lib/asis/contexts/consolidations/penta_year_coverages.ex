defmodule Asis.Contexts.Consolidations.PentaYearCoverages do
  @moduledoc """
  Manage `Asis.Contexts.Consolidations.PentaYearCoverage`.
  """

  import Ecto.Query, only: [where: 3]
  alias Asis.Contexts.Consolidations.PentaYearCoverage
  alias Asis.Repo

  @spec list_by_cities_and_period(list(integer()), map()) :: list(%PentaYearCoverage{})
  def list_by_cities_and_period(cities_ids, period) do
    PentaYearCoverage
    |> where([pyc], pyc.city_id in ^cities_ids)
    |> maybe_filter_by_year_from(Map.get(period, :year_from))
    |> maybe_filter_by_year_to(Map.get(period, :year_to))
    |> Repo.all()
  end

  defp maybe_filter_by_year_from(query, nil), do: query
  defp maybe_filter_by_year_from(query, year_from), do: where(query, [pyc], pyc.year >= ^year_from)

  defp maybe_filter_by_year_to(query, nil), do: query
  defp maybe_filter_by_year_to(query, year_to), do: where(query, [pyc], pyc.year <= ^year_to)

  @spec create(map()) :: {:ok, %PentaYearCoverage{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %PentaYearCoverage{}
    |> PentaYearCoverage.changeset(attrs)
    |> Repo.insert()
  end

  @spec add(%PentaYearCoverage{}, %PentaYearCoverage{}) :: %PentaYearCoverage{}
  def add(from, to) do
    Map.update(to, :total, 0, &(&1 + Map.get(from, :total, 0)))
  end
end
