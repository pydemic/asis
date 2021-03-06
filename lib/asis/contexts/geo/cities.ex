defmodule Asis.Contexts.Geo.Cities do
  @moduledoc """
  Manage `Asis.Contexts.Geo.City`.
  """

  import Ecto.Query, only: [where: 3, order_by: 3]
  alias Asis.Contexts.Geo.City
  alias Asis.Repo

  @spec list_by_health_region(integer()) :: list(%City{})
  def list_by_health_region(health_region_id) do
    City
    |> where([c], c.health_region_id == ^health_region_id)
    |> order_by([c], c.name)
    |> Repo.all()
  end

  @spec list_by_state(integer()) :: list(%City{})
  def list_by_state(state_id) do
    City
    |> where([c], c.state_id == ^state_id)
    |> order_by([c], c.name)
    |> Repo.all()
  end

  @spec get(integer()) :: %City{} | nil
  def get(id) do
    Repo.get(City, id)
  end

  @spec create(map()) :: {:ok, %City{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end
end
