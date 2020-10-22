defmodule AsisWeb.RoraimaLive.Structs.Births do
  @moduledoc """
  `AsisWeb.RoraimaLive` births struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Births

  @type t :: %Births{total: integer()}

  defstruct total: 0
end
