defmodule Asis.Release.Seeders.Contexts.ICD10.Disease do
  @moduledoc """
  Seed `Asis.Contexts.ICD10.Disease` data.
  """

  require Logger
  alias Asis.Contexts.ICD10
  alias Asis.Release.Seeders.CSVSeeder

  @path "icd_10/diseases.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  defp parse_and_seed([parent_block_id_1, parent_block_id_2, parent_block_id_3, id, name]) do
    {:ok, _disease} = ICD10.Diseases.create(%{id: id, name: name})

    maybe_create_parent_block(id, parent_block_id_1)
    maybe_create_parent_block(id, parent_block_id_2)
    maybe_create_parent_block(id, parent_block_id_3)
  rescue
    error -> Logger.error(Exception.message(error))
  end

  defp maybe_create_parent_block(id, parent_block_id) do
    if parent_block_id in [nil, ""] do
      :ok
    else
      {:ok, _block_disease} = ICD10.BlockDiseases.create(%{disease_id: id, block_id: parent_block_id})
    end
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
