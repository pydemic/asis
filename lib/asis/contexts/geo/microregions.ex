defmodule Asis.Contexts.Geo.Microregions do
  @moduledoc """
  Manage `Asis.Contexts.Geo.Microregion`.
  """

  alias Asis.Contexts.Geo.Microregion
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Microregion{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Microregion{}
    |> Microregion.changeset(attrs)
    |> Repo.insert()
  end

  @spec get!(integer()) :: %Microregion{}
  def get!(id) do
    Microregion
    |> Repo.get!(id)
  end
end
