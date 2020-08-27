defmodule Asis.Contexts.Geo.MicroregionTest do
  use Asis.DataCase
  alias Asis.Contexts.Geo.Microregion

  @moduletag :contexts

  describe "microregion" do
    test "changeset/2 with invalid data will not add parents of parents" do
      attrs = %{mesoregion_id: 0}

      assert %Ecto.Changeset{valid?: false} = Microregion.changeset(%Microregion{}, attrs)
    end
  end
end
