defmodule AsisWeb.RoraimaLive.Structs.Morbidities.SelectedRegion do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.SelectedRegion
  alias AsisWeb.RoraimaLive.Structs.Morbidities.SelectedRegion.Incidence
  alias AsisWeb.RoraimaLive.Structs.Params.Morbidity

  @type t :: %SelectedRegion{
          morbidities: list(Morbidity.t()),
          incidences: list(Incidence.t())
        }

  defstruct morbidities: [], incidences: []
end
