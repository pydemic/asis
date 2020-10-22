defmodule AsisWeb.RoraimaLive.Structs.Morbidities.Localized.Incidence do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.Localized.Incidence

  @type t :: %Incidence{
          id: String.t() | nil,
          name: String.t() | nil,
          sub_diseases: list(String.t()),
          diseases: list(String.t()),
          color: String.t() | nil,
          incidence: integer(),
          ratio: integer()
        }

  defstruct id: nil, name: nil, sub_diseases: [], diseases: [], color: nil, incidence: 0, ratio: 0

  @spec fetch_ratio(Incidence.t(), integer()) :: Incidence.t()
  def fetch_ratio(%{incidence: incidence} = struct, population) do
    ratio =
      if population != 0 do
        round(incidence / population * 100_000)
      else
        0
      end

    %Incidence{struct | ratio: ratio}
  end
end
