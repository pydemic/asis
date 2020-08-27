defmodule Asis.Release.Seeders.Contexts.ICD10.Block do
  @moduledoc """
  Seed `Asis.Contexts.ICD10.Block` data.
  """

  require Logger
  alias Asis.Contexts.ICD10
  alias Asis.Release.Seeders.CSVSeeder

  @path "icd_10/blocks.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, Keyword.put(opts, :sync, true))
  end

  defp parse_and_seed([chapter_id, parent_block_id, id, name]) do
    {:ok, _block} =
      %{
        chapter_id: chapter_id,
        id: id,
        name: name
      }
      |> maybe_add_parent_block(parent_block_id)
      |> ICD10.Blocks.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end

  defp parse_and_seed(values) do
    Logger.error(inspect(values))
  end

  defp maybe_add_parent_block(map, nil), do: map
  defp maybe_add_parent_block(map, ""), do: map
  defp maybe_add_parent_block(map, parent_block_id), do: Map.put(map, :parent_block_id, parent_block_id)
end
