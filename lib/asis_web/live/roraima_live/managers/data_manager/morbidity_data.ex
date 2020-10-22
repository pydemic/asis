defmodule AsisWeb.RoraimaLive.DataManager.MorbidityData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` morbidity data.
  """

  alias AsisWeb.RoraimaLive.DataManager.MorbidityData

  @spec fetch(map()) :: {map() | nil, map() | nil}
  def fetch(data) do
    {assigns, morbidity_data, _data} =
      {%{}, %{}, data}
      |> fetch_child(:selected_local_data, &MorbidityData.SelectedLocalData.fetch/2)
      |> fetch_child(:selected_period_data, &MorbidityData.SelectedPeriodData.fetch/2)
      |> fetch_child(:selected_region_data, &MorbidityData.SelectedRegionData.fetch/2)
      |> fetch_child(:selected_morbidity_data, &MorbidityData.SelectedMorbidityData.fetch/2)

    {assigns, morbidity_data}
  end

  defp fetch_child({assigns, morbidity_data, data}, key, function) do
    {function_assigns, function_data} = function.(morbidity_data, data)
    {put_if_not_nil(assigns, key, function_assigns), put_if_not_nil(morbidity_data, key, function_data), data}
  end

  defp put_if_not_nil(map, _key, nil), do: map
  defp put_if_not_nil(map, key, value), do: Map.put(map, key, value)
end
