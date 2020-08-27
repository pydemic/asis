defmodule Asis.Contexts.Geo.CityTest do
  use Asis.DataCase
  alias Asis.Contexts.Geo.City

  @moduletag :contexts

  describe "city" do
    test "changeset/2 with invalid data will not add parents of parents" do
      attrs = %{microregion_id: 0}

      assert %Ecto.Changeset{valid?: false} = City.changeset(%City{}, attrs)
    end
  end
end
