defmodule AsisWeb.RoraimaLive.DataManager.BirthData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` birth data.
  """

  alias Asis.Contexts.Registries.BirthRegistries
  alias AsisWeb.RoraimaLive.Structs.Params

  @current_year Params.current_year()

  @spec fetch(map()) :: {map() | nil, map() | nil}
  def fetch(%{params: %{year_from: from, year_to: to, cities_ids: cities}}) do
    coverage_year = coverage_year(to)

    registries = get_registries(cities, from, to, coverage_year)

    {local_births, coverage_births} = Enum.reduce(registries, {0, 0}, &count_birth(&2, &1, coverage_year))

    {%{local_births: local_births}, %{coverage_births: coverage_births}}
  end

  defp coverage_year(@current_year), do: @current_year - 1
  defp coverage_year(to), do: to

  defp get_registries(cities, from, to, coverage_year) do
    from =
      if coverage_year < from do
        coverage_year
      else
        from
      end

    BirthRegistries.list_by(cities: cities, from: from, to: to)
  end

  defp count_birth({local, coverage}, %{year: year}, year), do: {local + 1, coverage + 1}
  defp count_birth({local, coverage}, _registry, _year), do: {local + 1, coverage}
end
