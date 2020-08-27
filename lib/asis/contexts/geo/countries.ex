defmodule Asis.Contexts.Geo.Countries do
  @moduledoc """
  Manage `Asis.Contexts.Geo.Country`.
  """

  alias Asis.Contexts.Geo.Country
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Country{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @spec get!(integer()) :: %Country{}
  def get!(id) do
    Country
    |> Repo.get!(id)
  end
end
