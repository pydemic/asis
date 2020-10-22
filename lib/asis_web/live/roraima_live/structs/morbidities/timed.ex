defmodule AsisWeb.RoraimaLive.Structs.Morbidities.Timed do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidities struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Morbidities.Timed
  alias AsisWeb.RoraimaLive.Structs.Morbidities.Timed.Incidence

  @type t :: %Timed{populations: list(integer()), incidences: list(Incidence.t())}

  defstruct populations: 0, incidences: []
end
