defmodule AsisWeb.RoraimaLive.DataManager.MorbidityData.SelectedLocalData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` localized incidence data.
  """

  alias Asis.Contexts.Registries.MorbidityRegistries

  @spec fetch(map(), map()) :: {map() | nil, map() | nil}
  def fetch(_morbidity_data, data) do
    %{
      params: %{
        cities_ids: cities_ids,
        city_options: cities,
        morbidity_options: morbidities,
        week_from: week_from,
        week_to: week_to,
        year_to: year
      },
      demographic_data: %{
        local_population: population
      }
    } = data

    registries = MorbidityRegistries.list_by(cities: Enum.map(cities, & &1.id), week_from: week_from, week_to: week_to)
    selected_cities_registries = Enum.filter(registries, &(&1.city_id in cities_ids))
    selected_year_registries = Enum.filter(registries, &(&1.year == year))
    selected_cities_year_registries = Enum.filter(selected_cities_registries, &(&1.year == year))

    incidences = fetch_incidences(morbidities, selected_cities_year_registries, population)

    assigns = %{population: population, incidences: incidences}

    data = %{
      registries: registries,
      selected_cities_registries: selected_cities_registries,
      selected_year_registries: selected_year_registries,
      selected_cities_year_registries: selected_cities_year_registries,
      incidences: incidences
    }

    {assigns, data}
  end

  defp fetch_incidences(morbidities, registries, population) do
    morbidities
    |> Enum.reduce({[], registries}, &fetch_incidence(&1, &2, population))
    |> elem(0)
    |> Enum.sort(&(&1.incidence >= &2.incidence))
  end

  defp fetch_incidence(morbidity, {incidences, registries}, population) do
    %{id: id, name: name, sub_diseases: sub_diseases, diseases: diseases} = morbidity

    {local_registries, registries} = Enum.split_with(registries, &from_morbidity?(&1, sub_diseases, diseases))

    incidence = Enum.count(local_registries)

    color = "#" <> ColourHash.hex(id)

    data = %{
      id: id,
      name: name,
      sub_diseases: sub_diseases,
      diseases: diseases,
      color: color,
      incidence: incidence,
      ratio: calculate_ratio(incidence, population)
    }

    {[data] ++ incidences, registries}
  end

  defp from_morbidity?(%{sub_disease_id: sub_disease_id, disease_id: disease_id}, sub_diseases, diseases) do
    case {sub_diseases, diseases} do
      {sub_diseases, []} -> sub_disease_id in sub_diseases
      {[], diseases} -> disease_id in diseases
      _ -> sub_disease_id in sub_diseases or disease_id in diseases
    end
  end

  defp calculate_ratio(_incidence, 0), do: 0
  defp calculate_ratio(incidence, population), do: round(incidence / population * 100_000)
end
