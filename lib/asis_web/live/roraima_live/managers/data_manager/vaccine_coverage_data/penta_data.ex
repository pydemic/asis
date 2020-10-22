defmodule AsisWeb.RoraimaLive.DataManager.VaccineCoverageData.PentaData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` vaccine coverage data.
  """

  alias Asis.Contexts.Consolidations.PentaYearCoverages

  @spec fetch(list(String.t()), integer(), integer()) :: map()
  def fetch(cities, year, births) do
    vaccinations = PentaYearCoverages.sum_by(cities: cities, year: year)
    coverage = calculate_coverage(vaccinations, births)
    %{vaccinations: vaccinations, coverage: coverage}
  end

  defp calculate_coverage(_vaccinations, 0), do: 0
  defp calculate_coverage(vaccinations, births), do: round(vaccinations / births * 100.0)
end
