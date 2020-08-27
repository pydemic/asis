defmodule Asis.Release.Seeders.Contexts.Consolidations do
  @moduledoc """
  Seed `Asis.Contexts.Consolidations` data.
  """

  alias Asis.Release.Seeders.Contexts.Consolidations

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    Consolidations.CityYearPopulation.seed(opts)
  end
end
