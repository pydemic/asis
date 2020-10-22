defmodule AsisWeb.RoraimaLive.DataManager.VaccineCoverageData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` vaccine coverage data.
  """

  alias AsisWeb.RoraimaLive.DataManager.VaccineCoverageData.PentaData

  @spec fetch(map()) :: {map() | nil, map() | nil}
  def fetch(%{params: %{cities_ids: cities, year_to: year}, birth_data: %{coverage_births: births}}) do
    penta = PentaData.fetch(cities, year, births)
    {%{births: births, penta: penta}, nil}
  end
end
