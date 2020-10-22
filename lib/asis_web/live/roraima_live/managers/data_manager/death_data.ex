defmodule AsisWeb.RoraimaLive.DataManager.DeathData do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` death data.
  """

  alias Asis.Contexts.Registries.DeathRegistries

  @chapters [
    %{id: "I", name: "Doenças infecciosas e parasitárias"},
    %{id: "II", name: "Neoplasmas"},
    %{id: "III", name: "Doenças do sangue e dos órgãos hematopoéticos e alguns transtornos imunitários"},
    %{id: "IV", name: "Doenças endócrinas, nutricionais e metabólicas"},
    %{id: "V", name: "Transtornos mentais e comportamentais"},
    %{id: "VI", name: "Doenças do sistema nervoso"},
    %{id: "VII", name: "Doenças do olho e anexos"},
    %{id: "VIII", name: "Doenças do ouvido e da apófise mastóide"},
    %{id: "IX", name: "Doenças do aparelho circulatório"},
    %{id: "X", name: "Doenças do aparelho respiratório"},
    %{id: "XI", name: "Doenças do aparelho digestivo"},
    %{id: "XII", name: "Doenças da pele e do tecido subcutâneo"},
    %{id: "XII", name: "Doenças do sistema osteomuscular e do tecido conjuntivo"},
    %{id: "XIV", name: "Doenças do aparelho geniturinário"},
    %{id: "XV", name: "Gravidez, parto e puerpério"},
    %{id: "XVI", name: "Algumas afecções originadas no período perinatal"},
    %{id: "XVII", name: "Malformações congênitas, deformidades e anomalias cromossômicas"},
    %{
      id: "XVIII",
      name: "Sintomas, sinais e achados anormais de exames clínicos e de laboratório, não classificados em outra parte"
    },
    %{id: "XIX", name: "Lesões, envenenamentos e algumas outras conseqüências de causas externas"},
    %{id: "XX", name: "Causas externas de morbidade e de mortalidade"},
    %{id: "XXI", name: "Fatores que influenciam o estado de saúde e o contato com os serviços de saúde"},
    %{id: "XXII", name: "Casos especiais"}
  ]

  @spec fetch(map()) :: {map() | nil, map() | nil}
  def fetch(%{params: %{cities_ids: cities_ids, city_options: cities, year_to: year}}) do
    registries = DeathRegistries.list_by(cities: cities_ids, year: year)

    cities_deaths =
      cities
      |> Enum.reduce({[], registries}, &fetch_city_deaths/2)
      |> elem(0)
      |> Enum.reverse()

    {%{chapters: @chapters, cities_deaths: cities_deaths}, nil}
  end

  defp fetch_city_deaths(city, {cities_deaths, registries}) do
    %{id: id, name: name} = city

    {city_registries, registries} = Enum.split_with(registries, &(&1.city_id == id))

    chapters_deaths =
      @chapters
      |> Enum.reduce({[], city_registries}, &fetch_chapter_deaths/2)
      |> elem(0)
      |> Enum.reverse()

    total_deaths = Enum.sum(chapters_deaths)
    chapters_death_ratios = Enum.map(chapters_deaths, &calculate_ratio(&1, total_deaths))
    colors = Enum.map(chapters_death_ratios, &extract_color_from_ratio/1)

    data = %{
      id: id,
      name: name,
      colors: colors,
      deaths: chapters_deaths,
      total: total_deaths,
      ratios: chapters_death_ratios
    }

    {[data] ++ cities_deaths, registries}
  end

  defp fetch_chapter_deaths(%{id: id}, {chapters_deaths, registries}) do
    {chapter_registries, registries} = Enum.split_with(registries, &(&1.chapter_id == id))
    {[Enum.count(chapter_registries)] ++ chapters_deaths, registries}
  end

  defp calculate_ratio(_deaths, 0), do: 0
  defp calculate_ratio(deaths, total), do: round(deaths / total * 100)

  defp extract_color_from_ratio(ratio) do
    cond do
      ratio == 0 -> "#CCC"
      ratio < 20 -> "#87CEEB"
      ratio < 40 -> "#DDDD55"
      true -> "#FF9257"
    end
  end
end
