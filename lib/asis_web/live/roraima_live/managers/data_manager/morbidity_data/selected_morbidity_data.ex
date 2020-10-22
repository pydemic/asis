defmodule AsisWeb.RoraimaLive.DataManager.MorbidityData.SelectedMorbidityData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` localized incidence data.
  """

  @spec fetch(map(), map()) :: {map() | nil, map() | nil}
  def fetch(%{selected_local_data: %{selected_year_registries: registries}}, data) do
    %{
      params: %{
        city_options: cities,
        morbidity:
          %{
            sub_diseases: sub_diseases,
            diseases: diseases
          } = morbidity
      },
      demographic_data: %{
        cities_population: populations
      }
    } = data

    registries = Enum.filter(registries, &from_morbidity?(&1, sub_diseases, diseases))

    incidences = fetch_incidences(cities, registries, populations)

    labels = extract_labels(incidences)

    {%{morbidity: morbidity, labels: labels, incidences: colorize_incidences(incidences, labels)}, nil}
  end

  defp fetch_incidences(cities, registries, populations) do
    cities
    |> Enum.zip(populations)
    |> Enum.reduce({[], registries}, &fetch_incidence/2)
    |> elem(0)
    |> Enum.reverse()
  end

  defp fetch_incidence({city, population}, {incidence_data, registries}) do
    %{id: id, name: name} = city

    {city_registries, registries} = Enum.split_with(registries, &(&1.city_id == id))

    incidence = Enum.count(city_registries)

    data = %{
      id: id,
      name: name,
      population: population,
      incidence: incidence,
      ratio: calculate_ratio(incidence, population)
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

  defp calculate_ratio(_incidence, 0), do: 0
  defp calculate_ratio(incidence, population), do: round(incidence / population * 100_000)

  defp extract_labels(incidences) do
    ratios =
      incidences
      |> Enum.map(& &1.ratio)
      |> Enum.reject(&(&1 == 0))

    if Enum.any?(ratios) do
      q0 = 0
      q1 = round(Statistics.percentile(ratios, 20))
      q2 = round(Statistics.percentile(ratios, 40))
      q3 = round(Statistics.percentile(ratios, 60))
      q4 = round(Statistics.percentile(ratios, 80))

      [
        %{text: get_label_text(nil, q0), from: nil, to: q0, color: "#555"},
        %{text: get_label_text(q0, q1), from: q0, to: q1, color: "#228B22"},
        %{text: get_label_text(q1, q2), from: q1, to: q2, color: "#CC0"},
        %{text: get_label_text(q2, q3), from: q2, to: q3, color: "#FF8C00"},
        %{text: get_label_text(q3, q4), from: q3, to: q4, color: "#FF4500"},
        %{text: get_label_text(q4, nil), from: q4, to: nil, color: "#B22222"}
      ]
      |> Enum.reject(&is_nil(&1.text))
    end
  end

  defp get_label_text(from, to) do
    case {from, to} do
      {nil, to} -> to_string(to)
      {0, nil} -> nil
      {from, from} -> nil
      {from, to} when from > to -> nil
      {from, nil} -> "#{from + 1}+"
      {from, to} -> "#{from + 1}-#{to}"
    end
  end

  defp colorize_incidences(incidences, labels) do
    Enum.map(incidences, &colorize_incidence(&1, labels))
  end

  defp colorize_incidence(incidence, labels) do
    %{color: color} = Enum.find(labels || [], %{color: "#555"}, &ratio_on_boundary?(incidence, &1))
    Map.put(incidence, :color, color)
  end

  defp ratio_on_boundary?(%{ratio: ratio}, %{from: nil, to: to}), do: ratio <= to
  defp ratio_on_boundary?(%{ratio: ratio}, %{from: from, to: nil}), do: ratio >= from
  defp ratio_on_boundary?(%{ratio: ratio}, %{from: from, to: to}), do: ratio >= from and ratio <= to
end
