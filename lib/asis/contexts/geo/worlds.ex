defmodule Asis.Contexts.Geo.Worlds do
  @moduledoc """
  Manage `Asis.Contexts.Geo.World`.
  """

  alias Asis.Contexts.Geo.World
  alias Asis.Repo

  @spec create(map()) :: {:ok, %World{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %World{}
    |> World.changeset(attrs)
    |> Repo.insert()
  end
end
