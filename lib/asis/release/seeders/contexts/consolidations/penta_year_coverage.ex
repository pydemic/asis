defmodule Asis.Release.Seeders.Contexts.Consolidations.PentaYearCoverage do
  @moduledoc """
  Seed `Asis.Contexts.Consolidations.PentaYearCoverage` data.
  """

  require Logger
  alias Asis.Contexts.Consolidations.PentaYearCoverages
  alias Asis.Release.Seeders.CSVSeeder

  @path "consolidations/br/rr/penta_year_coverages"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(Path.join(@path, "2018.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2019.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2020.csv"), &parse_and_seed/1, opts)
  end

  @fields [:year, :city_id, :total]

  defp parse_and_seed(values) do
    {:ok, _penta_year_coverage} =
      @fields
      |> Enum.zip(Enum.map(values, &String.to_integer/1))
      |> Map.new()
      |> PentaYearCoverages.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
