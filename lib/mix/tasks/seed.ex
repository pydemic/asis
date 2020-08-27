defmodule Mix.Tasks.Seed do
  @moduledoc """
  Mix task to seed contexts.
  """

  use Mix.Task

  alias Asis.Release.Seeders.Contexts
  alias Asis.Release.Seeders.Contexts.{Consolidations, Geo, ICD10, Registries}

  @spec run(list(String.t())) :: none
  def run(args) do
    case args do
      ["sync" | args] -> do_run(args, sync: true)
      args -> do_run(args)
    end

    exit({:shutdown, 0})
  end

  defp do_run(args, opts \\ []) do
    Mix.Task.run("app.start")

    if Enum.empty?(args) do
      Contexts.seed_all(opts)
    else
      seed_each(args, opts)
    end
  end

  defp seed_each([context | args], opts), do: seed_and_continue(context, args, opts)
  defp seed_each(_args, _opts), do: :ok

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp seed_and_continue(context, args, opts) do
    case context do
      "consolidations" -> Consolidations.seed(opts)
      "consolidations.city_year_population" -> Consolidations.CityYearPopulation.seed(opts)
      "icd_10" -> ICD10.seed(opts)
      "icd_10.block" -> ICD10.Block.seed(opts)
      "icd_10.chapter" -> ICD10.Chapter.seed(opts)
      "icd_10.disease" -> ICD10.Disease.seed(opts)
      "icd_10.sub_disease" -> ICD10.SubDisease.seed(opts)
      "geo" -> Geo.seed(opts)
      "geo.city" -> Geo.City.seed(opts)
      "geo.continent" -> Geo.Continent.seed(opts)
      "geo.country" -> Geo.Country.seed(opts)
      "geo.mesoregion" -> Geo.Mesoregion.seed(opts)
      "geo.microregion" -> Geo.Microregion.seed(opts)
      "geo.region" -> Geo.Region.seed(opts)
      "geo.state" -> Geo.State.seed(opts)
      "geo.world" -> Geo.World.seed(opts)
      "registries" -> Registries.seed(opts)
      "registries.birth_registry" -> Registries.BirthRegistry.seed(opts)
      "registries.death_registry" -> Registries.DeathRegistry.seed(opts)
      "registries.morbidity_registry" -> Registries.MorbidityRegistry.seed(opts)
      _ -> :ok
    end

    seed_each(args, opts)
  end
end
