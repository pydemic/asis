defmodule AsisWeb.RoraimaLive.DataManager.MorbidityData.SelectedPeriodData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` localized incidence data.
  """

  @spec fetch(map(), map()) :: {map() | nil, map() | nil}
  def fetch(%{selected_local_data: %{selected_cities_registries: registries}}, data) do
    %{
      params: %{
        morbidity_options: morbidities
      },
      demographic_data: %{
        yearly_population: populations
      }
    } = data

    incidences = fetch_incidences(morbidities, registries, populations)

    {%{populations: populations, incidences: incidences}, nil}
  end

  defp fetch_incidences(morbidities, registries, populations) do
    morbidities
    |> Enum.reduce({[], registries}, &fetch_incidence(&1, &2, populations))
    |> elem(0)
    |> Enum.reverse()
  end

  defp fetch_incidence(morbidity, {incidence_data, registries}, populations) do
    %{id: id, name: name, sub_diseases: sub_diseases, diseases: diseases} = morbidity

    {morbidity_registries, registries} = Enum.split_with(registries, &from_morbidity?(&1, sub_diseases, diseases))

    {incidence_2018, incidence_2019, incidence_2020} = Enum.reduce(morbidity_registries, {0, 0, 0}, &count_incidence/2)

    incidences = [incidence_2018, incidence_2019, incidence_2020]

    color = "#" <> ColourHash.hex(id)

    data = %{
      id: id,
      name: name,
      sub_diseases: sub_diseases,
      diseases: diseases,
      color: color,
      incidences: incidences,
      ratios: calculate_ratios(incidences, populations)
    }

    {[data] ++ incidence_data, registries}
  end

  defp from_morbidity?(%{sub_disease_id: sub_disease_id, disease_id: disease_id}, sub_diseases, diseases) do
    case {sub_diseases, diseases} do
      {sub_diseases, []} -> sub_disease_id in sub_diseases
      {[], diseases} -> disease_id in diseases
      _ -> sub_disease_id in sub_diseases or disease_id in diseases
    end
  end

  defp count_incidence(%{year: 2018}, {i2018, i2019, i2020}), do: {i2018 + 1, i2019, i2020}
  defp count_incidence(%{year: 2019}, {i2018, i2019, i2020}), do: {i2018, i2019 + 1, i2020}
  defp count_incidence(%{year: 2020}, {i2018, i2019, i2020}), do: {i2018, i2019, i2020 + 1}
  defp count_incidence(_city_year_incidence, yearly_incidence), do: yearly_incidence

  defp calculate_ratios(incidences, ratios) do
    incidences
    |> Enum.zip(ratios)
    |> Enum.map(&calculate_ratio(elem(&1, 0), elem(&1, 1)))
  end

  defp calculate_ratio(_incidence, 0), do: 0
  defp calculate_ratio(incidence, population), do: round(incidence / population * 100_000)
end
