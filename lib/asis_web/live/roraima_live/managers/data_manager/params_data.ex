defmodule AsisWeb.RoraimaLive.DataManager.ParamsData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` params params.
  """

  alias Asis.Contexts.Geo
  alias AsisWeb.RoraimaLive.Structs.Params

  @state_id 14

  @spec fetch(map()) :: {map() | nil, map() | nil}
  def fetch(params) do
    params =
      %Params{state: Geo.States.get(@state_id), state_id: @state_id}
      |> fetch_if_param(Map.get(params, "year_from"), &fetch_year_from/2)
      |> fetch_if_param(Map.get(params, "year_to"), &fetch_year_to/2)
      |> fetch_if_param(Map.get(params, "week_from"), &fetch_week_from/2)
      |> fetch_if_param(Map.get(params, "week_to"), &fetch_week_to/2)
      |> fetch_health_region(Map.get(params, "health_region"))
      |> fetch_city(Map.get(params, "city"))
      |> fetch_if_param(Map.get(params, "morbidity"), &fetch_morbidity/2)
      |> Map.from_struct()

    {params, params}
  end

  defp fetch_if_param(params, nil, _function), do: params
  defp fetch_if_param(params, param, function), do: function.(params, param)

  defp fetch_year_from(%{year_from: default_from, year_from_options: options} = params, from) do
    %Params{params | year_from: parse_integer(from, default_from, options)}
  end

  defp fetch_year_to(%{year_from: from} = params, to) do
    current_year = Params.current_year()

    options =
      current_year
      |> Range.new(from)
      |> Enum.to_list()

    %Params{params | year_to: parse_integer(to, current_year, options), year_to_options: options}
  end

  defp fetch_week_from(%{week_from: default_from, week_from_options: options} = params, week_from) do
    %Params{params | week_from: parse_integer(week_from, default_from, options)}
  end

  defp fetch_week_to(%{week_from: from} = params, to) do
    maximum_week = Params.maximum_week()

    options =
      from
      |> Range.new(maximum_week)
      |> Enum.to_list()

    %Params{params | week_to: parse_integer(to, maximum_week, options), week_to_options: options}
  end

  defp fetch_health_region(%{state_id: state_id} = params, id) do
    id = parse_integer(id)

    health_region =
      if is_nil(id) do
        nil
      else
        Geo.HealthRegions.get(id)
      end

    health_regions = Geo.HealthRegions.list_by_state(state_id)

    %Params{params | health_region: health_region, health_region_id: id, health_region_options: health_regions}
  end

  defp fetch_city(%{health_region_id: health_region_id, state_id: state_id} = params, id) do
    id = parse_integer(id)

    city =
      if is_nil(id) do
        nil
      else
        Geo.Cities.get(id)
      end

    cities =
      if is_nil(health_region_id) do
        Geo.Cities.list_by_state(state_id)
      else
        Geo.Cities.list_by_health_region(health_region_id)
      end

    cities_ids =
      if is_nil(city) do
        Enum.map(cities, & &1.id)
      else
        [id]
      end

    %Params{params | cities_ids: cities_ids, city: city, city_id: id, city_options: cities}
  end

  defp fetch_morbidity(%{morbidity_options: morbidities} = params, id) do
    case Enum.find(morbidities, &(&1.id == id)) do
      nil -> params
      morbidity -> %Params{params | morbidity: morbidity, morbidity_id: id}
    end
  end

  defp parse_integer(integer, default \\ nil, boundary \\ nil)

  defp parse_integer(integer, default, boundary) when is_integer(integer) do
    if boundary == nil or integer in boundary do
      integer
    else
      default
    end
  end

  defp parse_integer(integer, default, boundary) do
    integer
    |> String.to_integer()
    |> parse_integer(default, boundary)
  rescue
    _error -> default
  end
end
