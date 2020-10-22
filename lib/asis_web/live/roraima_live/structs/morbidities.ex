defmodule AsisWeb.RoraimaLive.Structs.Morbidities do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities
  alias AsisWeb.RoraimaLive.Structs.Morbidities.{Localized, SelectedMorbidity, SelectedRegion, Timed}

  @type t :: %Morbidities{
          localized: Localized.t(),
          selected_morbidity: SelectedMorbidity.t(),
          selected_region: SelectedRegion.t(),
          timed: Timed.t()
        }

  defstruct localized: %Localized{},
            selected_morbidity: %SelectedMorbidity{},
            selected_region: %SelectedRegion{},
            timed: %Timed{}
end
