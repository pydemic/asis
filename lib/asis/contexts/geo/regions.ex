defmodule Asis.Contexts.Geo.Regions do
  @moduledoc """
  Manage `Asis.Contexts.Geo.Region`.
  """

  alias Asis.Contexts.Geo.Region
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Region{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Region{}
    |> Region.changeset(attrs)
    |> Repo.insert()
  end

  @spec get!(integer()) :: %Region{}
  def get!(id) do
    Region
    |> Repo.get!(id)
  end
end
