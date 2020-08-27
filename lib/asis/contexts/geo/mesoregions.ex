defmodule Asis.Contexts.Geo.Mesoregions do
  @moduledoc """
  Manage `Asis.Contexts.Geo.Mesoregion`.
  """

  alias Asis.Contexts.Geo.Mesoregion
  alias Asis.Repo

  @spec create(map()) :: {:ok, %Mesoregion{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Mesoregion{}
    |> Mesoregion.changeset(attrs)
    |> Repo.insert()
  end

  @spec get!(integer()) :: %Mesoregion{}
  def get!(id) do
    Mesoregion
    |> Repo.get!(id)
  end
end
