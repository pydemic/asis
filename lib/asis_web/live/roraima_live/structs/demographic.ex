defmodule AsisWeb.RoraimaLive.Structs.Demographic do
  @moduledoc """
  `AsisWeb.RoraimaLive` demographic struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Demographic

  @type t :: %Demographic{population: integer()}

  defstruct population: 0
end
