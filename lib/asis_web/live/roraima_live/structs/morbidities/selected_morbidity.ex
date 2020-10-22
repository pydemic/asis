defmodule AsisWeb.RoraimaLive.Structs.Morbidities.SelectedMorbidity do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.SelectedMorbidity
  alias AsisWeb.RoraimaLive.Structs.Morbidities.SelectedMorbidity.{Incidence, Label}
  alias AsisWeb.RoraimaLive.Structs.Params.Morbidity

  @type t :: %SelectedMorbidity{
          morbidity: Morbidity.t() | nil,
          labels: list(Label.t()),
          incidences: list(Incidence.t())
        }

  defstruct morbidity: nil, labels: [], incidences: []
end
