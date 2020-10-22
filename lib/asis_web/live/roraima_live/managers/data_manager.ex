defmodule AsisWeb.RoraimaLive.DataManager do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` data.
  """

  import Phoenix.LiveView, only: [assign: 2]
  alias AsisWeb.RoraimaLive.DataManager

  @spec update(LiveView.Socket.t(), map()) :: LiveView.Socket.t()
  def update(socket, params) do
    {params_assigns, params_data} = DataManager.ParamsData.fetch(params)

    assigns =
      {put_if_not_nil(%{}, :params, params_assigns), put_if_not_nil(%{}, :params, params_data)}
      |> fetch(:demographic_data, &DataManager.DemographicData.fetch/1)
      |> fetch(:birth_data, &DataManager.BirthData.fetch/1)
      |> fetch(:vaccine_coverage_data, &DataManager.VaccineCoverageData.fetch/1)
      |> fetch(:morbidity_data, &DataManager.MorbidityData.fetch/1)
      |> fetch(:death_data, &DataManager.DeathData.fetch/1)
      |> elem(0)

    assign(socket, assigns)
  end

  defp fetch({assigns, data}, key, function) do
    {function_assigns, function_data} = function.(data)
    {put_if_not_nil(assigns, key, function_assigns), put_if_not_nil(data, key, function_data)}
  end

  defp put_if_not_nil(map, _key, nil), do: map
  defp put_if_not_nil(map, key, value), do: Map.put(map, key, value)
end
