defmodule Asis.Release.Seeders.Contexts.ICD10.Chapter do
  @moduledoc """
  Seed `Asis.Contexts.ICD10.Chapter` data.
  """

  require Logger
  alias Asis.Contexts.ICD10
  alias Asis.Release.Seeders.CSVSeeder

  @path "icd_10/chapters.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  @fields [:id, :name, :code_start, :code_end]

  defp parse_and_seed(values) do
    {:ok, _chapter} =
      @fields
      |> Enum.zip(values)
      |> Map.new()
      |> ICD10.Chapters.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
