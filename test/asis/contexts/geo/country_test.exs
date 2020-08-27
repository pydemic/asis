defmodule Asis.Contexts.Geo.CountryTest do
  use Asis.DataCase
  alias Asis.Contexts.Geo.Country

  @moduletag :contexts

  describe "country" do
    test "changeset/2 with invalid data will not add parents of parents" do
      attrs = %{continent_id: 0}

      assert %Ecto.Changeset{valid?: false} = Country.changeset(%Country{}, attrs)
    end
  end
end
