defmodule Asis.Release.Seeders.Contexts.Registries do
  @moduledoc """
  Seed `Asis.Contexts.Registries` data.
  """

  alias Asis.Release.Seeders.Contexts.Registries

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    Registries.BirthRegistry.seed(opts)
    Registries.DeathRegistry.seed(opts)
    Registries.MorbidityRegistry.seed(opts)
  end
end
