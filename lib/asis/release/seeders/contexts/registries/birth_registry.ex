defmodule Asis.Release.Seeders.Contexts.Registries.BirthRegistry do
  @moduledoc """
  Seed `Asis.Contexts.Registries.BirthRegistry` data.
  """

  require Logger
  alias Asis.Contexts.Registries
  alias Asis.Release.Seeders.CSVSeeder

  @path "registries/birth_registries.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  @fields [numerodn: :integer, codmunnasc: :integer, codmunres: :integer]

  defp parse_and_seed(values) do
    {:ok, _birth_registry} =
      @fields
      |> Enum.zip(values)
      |> Enum.reduce(%{}, &parse_value/2)
      |> Registries.BirthRegistries.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end

  defp parse_value({{_field, _type}, nil}, map), do: map
  defp parse_value({{_field, _type}, ""}, map), do: map
  defp parse_value({{field, :integer}, value}, map) when is_integer(value), do: Map.put(map, field, value)
  defp parse_value({{field, :integer}, value}, map) when is_binary(value), do: parse_integer(map, field, value)
  defp parse_value({{field, :string}, value}, map) when is_binary(value), do: Map.put(map, field, value)
  defp parse_value({{field, :string}, value}, map), do: Map.put(map, field, to_string(value))
  defp parse_value(_, map), do: map

  defp parse_integer(map, field, value) do
    Map.put(map, field, String.to_integer(value))
  rescue
    _error ->
      Logger.warn(~s(Field "#{field}" with value "#{value}" cannot be converted to integer))
      map
  end
end
