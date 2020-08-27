defmodule Asis.Release.Seeders.Contexts.Registries.DeathRegistry do
  @moduledoc """
  Seed `Asis.Contexts.Registries.DeathRegistry` data.
  """

  require Logger
  alias Asis.Contexts.Registries
  alias Asis.Release.Seeders.CSVSeeder

  @path "registries/death_registries.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  @fields [numerodo: :integer, idade: :integer, codmunres: :integer, causabas_o: :string]

  defp parse_and_seed(values) do
    {:ok, _death_registry} =
      @fields
      |> Enum.zip(values)
      |> Enum.reduce(%{}, &parse_value/2)
      |> Registries.DeathRegistries.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end

  defp parse_value({{_field, _type}, nil}, map), do: map
  defp parse_value({{_field, _type}, ""}, map), do: map
  defp parse_value({{:causabas_o, _type}, value}, map) when is_binary(value), do: parse_disease(map, value)
  defp parse_value({{field, :integer}, value}, map) when is_integer(value), do: Map.put(map, field, value)
  defp parse_value({{field, :integer}, value}, map) when is_binary(value), do: parse_integer(map, field, value)
  defp parse_value({{field, :string}, value}, map) when is_binary(value), do: Map.put(map, field, value)
  defp parse_value({{field, :string}, value}, map), do: Map.put(map, field, to_string(value))
  defp parse_value(_, map), do: map

  defp parse_disease(map, value) do
    map = Map.put(map, :causabas_o, value)

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

      _length ->
        map
    end
  end

  defp parse_integer(map, field, value) do
    Map.put(map, field, String.to_integer(value))
  rescue
    _error ->
      Logger.warn(~s(Field "#{field}" with value "#{value}" cannot be converted to integer))
      map
  end
end