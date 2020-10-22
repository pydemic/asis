defmodule AsisWeb.RoraimaLive.Structs.Params.Morbidity do
  @moduledoc """
  `AsisWeb.RoraimaLive` morbidity data struct.
  """

  alias AsisWeb.RoraimaLive.Structs.Params.Morbidity

  @type t :: %Morbidity{
          id: String.t() | nil,
          name: String.t() | nil,
          sub_diseases: list(String.t()),
          diseases: list(String.t())
        }

  defstruct id: nil, name: nil, sub_diseases: [], diseases: []

  @spec new(keyword()) :: Morbidity.t()
  def new(params) do
    Morbidity
    |> struct(params)
    |> generate_id()
  end

  defp generate_id(%{sub_diseases: sub_diseases, diseases: diseases} = morbidity) do
    %Morbidity{morbidity | id: Enum.join(diseases, ",") <> Enum.join(sub_diseases, ",")}
  end
end
