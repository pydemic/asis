defmodule Asis.Contexts.Geo.States do
  @moduledoc """
  Manage `Asis.Contexts.Geo.State`.
  """

  alias Asis.Contexts.Geo.State
  alias Asis.Repo

  @spec create(map()) :: {:ok, %State{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @spec get!(integer()) :: %State{}
  def get!(id) do
    State
    |> Repo.get!(id)
  end
end
