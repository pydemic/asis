defmodule Asis.Contexts.Geo.RegionTest do
  use Asis.DataCase
  alias Asis.Contexts.Geo.Region

  @moduletag :contexts

  describe "region" do
    test "changeset/2 with invalid data will not add parents of parents" do
      attrs = %{country_id: 0}

      assert %Ecto.Changeset{valid?: false} = Region.changeset(%Region{}, attrs)
    end
  end
end
