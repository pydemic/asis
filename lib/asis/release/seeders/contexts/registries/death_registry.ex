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
    |> fetch_chapter()
  end

  @chapters_ids [
    {"I", [{"A", nil}, {"B", nil}]},
    {"II", [{"C", nil}, {"D", {0, 48}}]},
    {"III", [{"D", {50, 89}}]},
    {"IV", [{"E", nil}]},
    {"V", [{"F", nil}]},
    {"VI", [{"G", nil}]},
    {"VII", [{"H", {0, 59}}]},
    {"VIII", [{"H", {60, 95}}]},
    {"IX", [{"I", nil}]},
    {"X", [{"J", nil}]},
    {"XI", [{"K", nil}]},
    {"XII", [{"L", nil}]},
    {"XIII", [{"M", nil}]},
    {"XIV", [{"N", nil}]},
    {"XV", [{"O", nil}]},
    {"XVI", [{"P", nil}]},
    {"XVII", [{"Q", nil}]},
    {"XVIII", [{"R", nil}]},
    {"XIX", [{"S", nil}, {"T", nil}]},
    {"XX", [{"V", nil}, {"W", nil}, {"X", nil}, {"Y", nil}]},
    {"XXI", [{"Z", nil}]},
    {"XXII", [{"U", nil}]}
  ]

  defp fetch_chapter(%{disease_id: disease_id} = map) do
    {chapter_id, _ids} = Enum.find(@chapters_ids, &disease_id_match_chapter?(&1, disease_id))
    Map.put(map, :chapter_id, chapter_id)
  end

  defp disease_id_match_chapter?({_chapter_id, ids}, disease_id) do
    {letter, number} = String.split_at(disease_id, 1)
    number = String.to_integer(number)

    Enum.any?(ids, &disease_id_in_group?(&1, letter, number))
  end

  defp disease_id_in_group?({letter, nil}, letter, _number), do: true
  defp disease_id_in_group?({letter, {from, to}}, letter, number), do: number >= from and number <= to
  defp disease_id_in_group?(_group, _letter, _number), do: false

  defp parse_death_date(map, value) do
    value =
      case String.length(value) do
        7 -> String.slice(value, 3, 4)
        8 -> String.slice(value, 4, 4)
      end

    Map.put(map, :year, String.to_integer(value))
  end
end
