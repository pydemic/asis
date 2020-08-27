defmodule Asis.Contexts.Geo.Continents do
  @moduledoc """
  Manage `Asis.Contexts.Geo.Continent`.
  """

  alias Asis.Contexts.Geo.Continent
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Continent{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Continent{}
    |> Continent.changeset(attrs)
    |> Repo.insert()
  end

  @spec get!(integer()) :: %Continent{}
  def get!(id) do
    Continent
    |> Repo.get!(id)
  end
end
