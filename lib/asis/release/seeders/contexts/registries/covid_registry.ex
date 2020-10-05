defmodule Asis.Release.Seeders.Contexts.Registries.CovidRegistry do
  @moduledoc """
  Seed `Asis.Contexts.Registries.CovidRegistry` data.
  """

  require Logger
  alias Asis.Contexts.Registries
  alias Asis.Release.Seeders.CSVSeeder

  @path "registries/br/rr/covid_registries"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(Path.join(@path, "2020.csv"), &parse_and_seed/1, opts)
  end

  @fields [id: :string, date: :date, is_positive: :boolean, city_id: :integer]

  defp parse_and_seed(values) do
    {:ok, _covid_registry} =
      @fields
      |> Enum.zip(values)
      |> Enum.reduce(%{}, &parse_value/2)
      |> Registries.CovidRegistries.create()
  rescue
    error -> Logger.error(Exception.message(error) <> "\nValues: " <> inspect(values))
  end

  defp parse_value({{field, :boolean}, value}, map), do: Map.put(map, field, value == "Positivo")
  defp parse_value({{field, :string}, value}, map), do: Map.put(map, field, value)
  defp parse_value({{field, :integer}, value}, map), do: Map.put(map, field, String.to_integer(value))
  defp parse_value({{field, :date}, value}, map), do: Map.put(map, field, Date.from_iso8601!(value))
end
