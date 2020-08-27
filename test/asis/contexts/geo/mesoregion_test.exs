defmodule Asis.Contexts.Geo.MesoregionTest do
  use Asis.DataCase
  alias Asis.Contexts.Geo.Mesoregion

  @moduletag :contexts

  describe "mesoregion" do
    test "changeset/2 with invalid data will not add parents of parents" do
      attrs = %{state_id: 0}

      assert %Ecto.Changeset{valid?: false} = Mesoregion.changeset(%Mesoregion{}, attrs)
    end
  end
end
