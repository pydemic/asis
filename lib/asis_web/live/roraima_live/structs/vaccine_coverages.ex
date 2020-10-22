defmodule AsisWeb.RoraimaLive.Structs.VaccineCoverages do
  @moduledoc """
  `AsisWeb.RoraimaLive` vaccine coverages struct.
  """

  alias AsisWeb.RoraimaLive.Structs.VaccineCoverages
  alias AsisWeb.RoraimaLive.Structs.VaccineCoverages.Penta

  @type t :: %VaccineCoverages{births: integer(), penta: Penta.t()}

  defstruct births: 0, penta: %Penta{}
end
