defmodule Asis.Release.Seeders.Contexts.Registries.BirthRegistry do
  @moduledoc """
  Seed `Asis.Contexts.Registries.BirthRegistry` data.
  """

  require Logger
  alias Asis.Contexts.Registries
  alias Asis.Release.Seeders.CSVSeeder

  @path "registries/br/rr/birth_registries"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(Path.join(@path, "2018.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2019.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2020.csv"), &parse_and_seed/1, opts)
  end

  @fields [id: :integer, city_id: :integer, home_city_id: :integer, birth_date: :string]

  defp parse_and_seed(values) do
    {:ok, _birth_registry} =
      @fields
      |> Enum.zip(values)
      |> Enum.reduce(%{}, &parse_value/2)
      |> Registries.BirthRegistries.create()
  rescue
    error -> Logger.error(Exception.message(error) <> "\nValues: " <> inspect(values))
  end

  defp parse_value({{:birth_date, :string}, value}, map), do: parse_birth_date(map, value)
  defp parse_value({{field, :integer}, value}, map), do: Map.put(map, field, String.to_integer(value))
  defp parse_value({{_field, :string}, ""}, map), do: map
  defp parse_value({{field, :string}, value}, map), do: Map.put(map, field, value)

  defp parse_birth_date(map, value) do
    value =
      case String.length(value) do
        7 -> String.slice(value, 3, 4)
        8 -> String.slice(value, 4, 4)
      end

    Map.put(map, :year, String.to_integer(value))
  end
end
