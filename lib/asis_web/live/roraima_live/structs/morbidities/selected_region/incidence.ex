defmodule AsisWeb.RoraimaLive.Structs.Morbidities.SelectedRegion.Incidence do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.SelectedRegion.Incidence

  @type t :: %Incidence{
          id: integer() | nil,
          name: String.t() | nil,
          colors: list(String.t()),
          population: integer(),
          incidences: list(integer()),
          ratios: list(integer())
        }

  defstruct id: nil, name: nil, colors: [], population: 0, incidences: [], ratios: []

  @spec fetch_ratios(Incidence.t()) :: Incidence.t()
  def fetch_ratios(%{incidences: incidences, population: population} = struct) do
    ratios = Enum.map(incidences, &calculate_ratio(&1, population))

    %Incidence{struct | ratios: ratios}
  end

  defp calculate_ratio(_incidence, 0), do: 0
  defp calculate_ratio(incidence, population), do: round(incidence / population * 100_000)
end
