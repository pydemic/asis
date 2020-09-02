defmodule Asis.Contexts.Geo.HealthRegions do
  @moduledoc """
  Manage `Asis.Contexts.Geo.HealthRegion`.
  """

  alias Asis.Contexts.Geo.HealthRegion
  alias Asis.Repo

  @spec create(map()) :: {:ok, %HealthRegion{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %HealthRegion{}
    |> HealthRegion.changeset(attrs)
    |> Repo.insert()
  end
end
