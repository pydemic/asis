defmodule Asis.Release.Seeders.Contexts.Registries.MorbidityRegistry do
  @moduledoc """
  Seed `Asis.Contexts.Registries.MorbidityRegistry` data.
  """

  require Logger
  alias Asis.Contexts.Registries
  alias Asis.Release.Seeders.CSVSeeder

  @path "registries/br/rr/morbidity_registries"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(Path.join(@path, "2018.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2019.csv"), &parse_and_seed/1, opts)
    CSVSeeder.seed(Path.join(@path, "2020.csv"), &parse_and_seed/1, opts)
  end

  @fields [id: :integer, disease_id_or_sub_disease_id: :string, year_and_week: :string, city_id: :integer, age: :integer]

  defp parse_and_seed(values) do
    {:ok, _morbidity_registry} =
      @fields
      |> Enum.zip(values)
      |> Enum.reduce(%{}, &parse_value/2)
      |> Registries.MorbidityRegistries.create()
  rescue
    error -> Logger.error(Exception.message(error) <> "\nValues: " <> inspect(values))
  end

  defp parse_value({{:id, _type}, _value}, map), do: map
  defp parse_value({{:disease_id_or_sub_disease_id, _type}, value}, map), do: parse_disease(map, value)
  defp parse_value({{:year_and_week, _type}, value}, map), do: parse_year_and_week(map, value)
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

  defp parse_year_and_week(map, value) do
    {year, week} = String.split_at(value, 4)

    map
    |> Map.put(:year, String.to_integer(year))
    |> Map.put(:week, String.to_integer(week))
  end
end
