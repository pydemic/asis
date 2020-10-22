defmodule Asis.Contexts.Registries.BirthRegistries do
  @moduledoc """
  Manage `Asis.Contexts.Registries.BirthRegistry`.
  """

  import Ecto.Query, only: [select: 3, where: 3]
  alias Asis.Contexts.Registries.BirthRegistry
  alias Asis.Repo

  @spec list_by(keyword()) :: list(%BirthRegistry{})
  def list_by(params) do
    BirthRegistry
    |> filter_by_params(params)
    |> Repo.all()
  end

  @spec count_by(keyword()) :: integer()
  def count_by(params) do
    BirthRegistry
    |> filter_by_params(params)
    |> select([br], count())
    |> Repo.one()
  end

  @spec create(map()) :: {:ok, %BirthRegistry{}} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %BirthRegistry{}
    |> BirthRegistry.changeset(attrs)
    |> Repo.insert()
  end

  defp filter_by_params(query, params) do
    if Enum.any?(params) do
      [param | params] = params

      case param do
        {:cities, cities} -> where(query, [br], br.city_id in ^cities)
        {:from, from} -> where(query, [br], br.year >= ^from)
        {:to, to} -> where(query, [br], br.year <= ^to)
        {:year, year} -> where(query, [br], br.year == ^year)
        _unknown_param -> query
      end
      |> filter_by_params(params)
    else
      query
    end
  end
end
