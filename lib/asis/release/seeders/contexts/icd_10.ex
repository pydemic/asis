defmodule Asis.Release.Seeders.Contexts.ICD10 do
  @moduledoc """
  Seed `Asis.Contexts.ICD10` data.
  """

  alias Asis.Release.Seeders.Contexts.ICD10

  @spec seed(keyword()) :: :ok
  def seed(opts \\ []) do
    ICD10.Chapter.seed(opts)
    ICD10.Block.seed(opts)
    ICD10.Disease.seed(opts)
    ICD10.SubDisease.seed(opts)
  end
end
