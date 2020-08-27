defmodule Asis.Contexts.Consolidations.CitiesYearPopulation do
  @moduledoc """
  Manage `Asis.Contexts.Consolidations.CityYearPopulation`.
  """

  alias Asis.Contexts.Consolidations.CityYearPopulation
  alias Asis.Repo

  @spec create(map()) :: {:ok, %CityYearPopulation{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %CityYearPopulation{}
    |> CityYearPopulation.changeset(attrs)
    |> Repo.insert()
  end
end
