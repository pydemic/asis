defmodule AsisWeb.RoraimaLive.Structs.Morbidities.SelectedMorbidity.Incidence do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.SelectedMorbidity.Incidence

  @type t :: %Incidence{
          id: integer | nil,
          name: String.t() | nil,
          color: String.t(),
          population: integer(),
          incidence: integer(),
          ratio: integer()
        }

  @derive Jason.Encoder
  defstruct id: nil, name: nil, color: "#555", population: 0, incidence: 0, ratio: 0

  @spec fetch_ratio(Incidence.t()) :: Incidence.t()
  def fetch_ratio(%{incidence: incidence, population: population} = struct) do
    ratio =
      if population != 0 do
        round(incidence / population * 100_000)
      else
        0
      end

    %Incidence{struct | ratio: ratio}
  end
end
