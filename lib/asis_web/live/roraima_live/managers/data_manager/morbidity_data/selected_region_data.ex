defmodule AsisWeb.RoraimaLive.DataManager.MorbidityData.SelectedRegionData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` localized incidence data.
  """

  @spec fetch(map(), map()) :: {map() | nil, map() | nil}
  def fetch(%{selected_local_data: %{incidences: incidences, selected_year_registries: selected_year_registries}}, data) do
    %{
      params: %{
        city_options: cities
      },
      demographic_data: %{
        cities_population: populations
      }
    } = data

    morbidities = Enum.slice(incidences, 0, 10)

    incidences = fetch_incidences(cities, morbidities, populations, selected_year_registries)

    incidences =
      morbidities
      |> Enum.with_index()
      |> Enum.map(&identify_quartile(&1, incidences))
      |> fetch_colors(incidences)

    {%{morbidities: morbidities, incidences: incidences}, nil}
  end

  defp fetch_incidences(cities, morbidities, populations, registries) do
    cities
    |> Enum.zip(populations)
    |> Enum.reduce({[], registries}, &fetch_city_incidences(&1, &2, morbidities))
    |> elem(0)
    |> Enum.reverse()
  end

  defp fetch_city_incidences({city, population}, {incidence_data, registries}, morbidities) do
    %{id: id, name: name} = city

    {city_registries, registries} = Enum.split_with(registries, &(&1.city_id == id))

    incidences =
      morbidities
      |> Enum.reduce({[], city_registries}, &fetch_incidence/2)
      |> elem(0)
      |> Enum.reverse()

    ratios = Enum.map(incidences, &calculate_ratio(&1, population))

    data = %{
      id: id,
      name: name,
      population: population,
      incidences: incidences,
      ratios: ratios
    }

    {[data] ++ incidence_data, registries}
  end

  defp fetch_incidence(morbidity, {incidences, registries}) do
    %{sub_diseases: sub_diseases, diseases: diseases} = morbidity

    {morbidity_registries, registries} = Enum.split_with(registries, &from_morbidity?(&1, sub_diseases, diseases))

    {[Enum.count(morbidity_registries)] ++ incidences, registries}
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

  defp identify_quartile({_morbidity, index}, incidences) do
    ratios =
      incidences
      |> Enum.map(&Enum.at(&1.ratios, index, 0))
      |> Enum.reject(&(&1 == 0))

    if Enum.any?(ratios) do
      {round(Statistics.percentile(ratios, 25)), round(Statistics.percentile(ratios, 75))}
    else
      {0, 0}
    end
  end

  defp fetch_colors(quartiles, incidences) do
    Enum.map(incidences, &do_fetch_colors(&1, quartiles))
  end

  defp do_fetch_colors(%{ratios: ratios} = incidence, quartiles) do
    colors =
      ratios
      |> Enum.zip(quartiles)
      |> Enum.map(&define_color/1)

    Map.put(incidence, :colors, colors)
  end

  defp define_color({ratio, {q1, q2}}) do
    if q1 != 0 and q2 != 0 do
      cond do
        ratio == 0 -> "#CCC"
        ratio <= q1 -> "#87CEEB"
        ratio <= q2 -> "#DDDD55"
        true -> "#FF9257"
      end
    else
      "#CCC"
    end
  end
end
