defmodule Asis.Release.Seeders.Contexts.Registries.DeathRegistry do
  @moduledoc """
  Seed `Asis.Contexts.Registries.DeathRegistry` data.
  """

  require Logger
  alias Asis.Contexts.Registries
  alias Asis.Release.Seeders.CSVSeeder

  @path "registries/br/rr/death_registries"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(Path.join(@path, "2018.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2019.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2020.csv"), &parse_and_seed/1, opts)
  end

  @fields [id: :integer, death_date: :string, age: :integer, city_id: :integer, disease_id_or_sub_disease_id: :string]

  defp parse_and_seed(values) do
    {:ok, _death_registry} =
      @fields
      |> Enum.zip(values)
      |> Enum.reduce(%{}, &parse_value/2)
      |> Registries.DeathRegistries.create()
  rescue
    error -> Logger.error(Exception.message(error) <> "\nValues: " <> inspect(values))
  end

  defp parse_value({{:death_date, _type}, value}, map), do: parse_death_date(map, value)
  defp parse_value({{:disease_id_or_sub_disease_id, _type}, value}, map), do: parse_disease(map, value)
  defp parse_value({{:age, _type}, ""}, map), do: Map.put(map, :age, -1)
  defp parse_value({{field, :integer}, value}, map), do: Map.put(map, field, String.to_integer(value))
  defp parse_value({{_field, :string}, ""}, map), do: map
  defp parse_value({{field, :string}, value}, map), do: Map.put(map, field, value)

  defp parse_disease(map, value) do
    case String.length(value) do
      3 ->
        Map.put(map, :disease_id, value)

      4 ->
        disease_id = String.slice(value, 0, 3)
        sub_disease_id = disease_id <> "." <> String.slice(value, 3, 1)

        map
        |> Map.put(:disease_id, disease_id)
        |> Map.put(:sub_disease_id, sub_disease_id)

      5 ->
        disease_id = String.slice(value, 0, 3)
        sub_disease_id = value

        map
        |> Map.put(:disease_id, disease_id)
        |> Map.put(:sub_disease_id, sub_disease_id)
    end
  end

  defp parse_death_date(map, value) do
    value =
      case String.length(value) do
        7 -> String.slice(value, 3, 4)
        8 -> String.slice(value, 4, 4)
      end

    Map.put(map, :year, String.to_integer(value))
  end
end
