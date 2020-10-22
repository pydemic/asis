defmodule AsisWeb.RoraimaLive.Structs.VaccineCoverages.Penta do
  @moduledoc """
  `AsisWeb.RoraimaLive` penta struct.
  """

  alias AsisWeb.RoraimaLive.Structs.VaccineCoverages.Penta

  @type t :: %Penta{vaccinations: integer(), coverage: integer()}

  defstruct vaccinations: 0, coverage: 0

  @spec fetch_coverage(Penta.t(), integer()) :: Penta.t()
  def fetch_coverage(%{vaccinations: vaccinations} = struct, births) do
    %Penta{struct | coverage: calculate_coverage(vaccinations, births)}
  end

  defp calculate_coverage(_vaccinations, 0), do: 0
  defp calculate_coverage(vaccinations, births), do: round(vaccinations / births * 100.0)
end
