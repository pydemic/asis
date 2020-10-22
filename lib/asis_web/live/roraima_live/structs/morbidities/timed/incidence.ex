defmodule AsisWeb.RoraimaLive.Structs.Morbidities.Timed.Incidence do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.Timed.Incidence

  @type t :: %Incidence{
          id: String.t() | nil,
          name: String.t() | nil,
          sub_diseases: list(String.t()),
          diseases: list(String.t()),
          color: String.t() | nil,
          incidences: list(integer()),
          ratios: list(integer())
        }

  defstruct id: nil, name: nil, sub_diseases: [], diseases: [], color: nil, incidences: [], ratios: []

  @spec fetch_ratios(Incidence.t(), list(integer())) :: Incidence.t()
  def fetch_ratios(%{incidences: incidences} = incidence, populations) do
    ratios =
      incidences
      |> Enum.zip(populations)
      |> Enum.map(fn {incidence, population} -> calculate_ratio(incidence, population) end)

    %Incidence{incidence | ratios: ratios}
  end

  defp calculate_ratio(_incidence, 0), do: 0
  defp calculate_ratio(incidence, population), do: round(incidence / population * 100_000)
end
