defmodule Asis.Release.Seeders.ContextsTest do
  use Asis.DataCase
  alias Asis.Release.Seeders.Contexts

  @moduletag :seeders

  describe "seeders_contexts" do
    test "seed_all/1 seed data successfully" do
      assert :ok = Contexts.seed_all()
    end
  end
end
