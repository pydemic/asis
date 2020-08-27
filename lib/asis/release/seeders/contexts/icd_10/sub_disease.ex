defmodule Asis.Release.Seeders.Contexts.ICD10.SubDisease do
  @moduledoc """
  Seed `Asis.Contexts.ICD10.SubDisease` data.
  """

  require Logger
  alias Asis.Contexts.ICD10
  alias Asis.Release.Seeders.CSVSeeder

  @path "icd_10/sub_diseases.csv"

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    CSVSeeder.seed(@path, &parse_and_seed/1, opts)
  end

  @fields [:disease_id, :id, :name]

  defp parse_and_seed(values) do
    {:ok, _sub_disease} =
      @fields
      |> Enum.zip(values)
      |> Map.new()
      |> ICD10.SubDiseases.create()
  rescue
    error -> Logger.error(Exception.message(error))
  end
end
