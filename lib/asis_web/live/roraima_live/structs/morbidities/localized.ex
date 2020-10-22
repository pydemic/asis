defmodule AsisWeb.RoraimaLive.Structs.Morbidities.Localized do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.Localized
  alias AsisWeb.RoraimaLive.Structs.Morbidities.Localized.Incidence

  @type t :: %Localized{population: integer(), incidences: list(Incidence.t())}

  defstruct population: 0, incidences: []
end
