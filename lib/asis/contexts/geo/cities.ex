defmodule Asis.Contexts.Geo.Cities do
  @moduledoc """
  Manage `Asis.Contexts.Geo.City`.
  """

  alias Asis.Contexts.Geo.City
  alias Asis.Repo

  @spec create(map()) :: {:ok, %City{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end
end
