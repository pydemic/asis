defmodule Asis.Contexts.Geo.HealthRegions do
  @moduledoc """
  Manage `Asis.Contexts.Geo.HealthRegion`.
  """

  import Ecto.Query, only: [where: 3]
  alias Asis.Contexts.Geo.HealthRegion
  alias Asis.Repo

  @spec list_by_state(integer()) :: list(%HealthRegion{})
  def list_by_state(state_id) do
    HealthRegion
    |> where([c], c.state_id == ^state_id)
    |> Repo.all()
  end

  @spec create(map()) :: {:ok, %HealthRegion{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %HealthRegion{}
    |> HealthRegion.changeset(attrs)
    |> Repo.insert()
  end
end
