defmodule Asis.Contexts.Geo.StateTest do
  use Asis.DataCase
  alias Asis.Contexts.Geo.State

  @moduletag :contexts

  describe "state" do
    test "changeset/2 with invalid data will not add parents of parents" do
      attrs = %{region_id: 0}

      assert %Ecto.Changeset{valid?: false} = State.changeset(%State{}, attrs)
    end
  end
end
