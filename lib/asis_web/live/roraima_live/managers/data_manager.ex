defmodule AsisWeb.RoraimaLive.DataManager do
  @moduledoc """
  Manage `AsisWeb.RoraimaLive` data.
  """

  import Phoenix.LiveView, only: [assign: 2, assign: 3]
  alias Asis.Contexts.{Consolidations, Geo, Registries}

  @state_id 14

  @minimum_year 2018
  @current_year 2020

  @minimum_week 1
  @maximum_week 53

  @default_morbidity_id "X20,X21,X22,X23,X24,X25,X26,X27,X29"

  @table_morbidities [
    {"Malária", "B50,B51,B52,B53,B54"},
    {"Dengue", "A90,A91"},
    {"Acidentes com animais peçonhetos", "X20,X21,X22,X23,X24,X25,X26,X27,X29"},
    {"Mordedura provocada por cão", "W54"},
    {"HIV/AIDS", "B20,B21,B22,B23,B24"},
    {"Sífilis congênita em menores de 1 ano de idade", "A50"}
  ]

  @chapters_names [
    "Doenças infecciosas e parasitárias",
    "Neoplasmas",
    "Doenças do sangue e dos órgãos hematopoéticos e alguns transtornos imunitários",
    "Doenças endócrinas, nutricionais e metabólicas",
    "Transtornos mentais e comportamentais",
    "Doenças do sistema nervoso",
    "Doenças do olho e anexos",
    "Doenças do ouvido e da apófise mastóide",
    "Doenças do aparelho circulatório",
    "Doenças do aparelho respiratório",
    "Doenças do aparelho digestivo",
    "Doenças da pele e do tecido subcutâneo",
    "Doenças do sistema osteomuscular e do tecido conjuntivo",
    "Doenças do aparelho geniturinário",
    "Gravidez, parto e puerpério",
    "Algumas afecções originadas no período perinatal",
    "Malformações congênitas, deformidades e anomalias cromossômicas",
    "Sintomas, sinais e achados anormais de exames clínicos e de laboratório, não classificados em outra parte",
    "Lesões, envenenamentos e algumas outras conseqüências de causas externas",
    "Causas externas de morbidade e de mortalidade",
    "Fatores que influenciam o estado de saúde e o contato com os serviços de saúde",
    "Casos especiais",
    "Causas desconhecidas"
  ]

  @chapters_ids [
    [{"A", nil}, {"B", nil}],
    [{"C", nil}, {"D", {0, 48}}],
    [{"D", {50, 89}}],
    [{"E", nil}],
    [{"F", nil}],
    [{"G", nil}],
    [{"H", {0, 59}}],
    [{"G", {60, 95}}],
    [{"I", nil}],
    [{"J", nil}],
    [{"K", nil}],
    [{"L", nil}],
    [{"M", nil}],
    [{"N", nil}],
    [{"O", nil}],
    [{"P", nil}],
    [{"Q", nil}],
    [{"R", nil}],
    [{"S", nil}, {"T", nil}],
    [{"V", nil}, {"Y", nil}],
    [{"Z", nil}],
    [{"U", nil}]
  ]

  @spec update(LiveView.Socket.t(), map()) :: LiveView.Socket.t()
  def update(socket, params) do
    socket
    |> assign(:state, Geo.States.get(@state_id))
    |> fetch_params(params)
    |> fetch_demographic_data()
    |> fetch_birth_data()
    |> fetch_vaccine_coverage_data()
    |> fetch_morbidity_data()
    |> fetch_death_data()
  end

  defp fetch_params(socket, params) do
    socket
    |> fetch_year_from(Map.get(params, "year_from"))
    |> fetch_year_to(Map.get(params, "year_to"))
    |> fetch_week_from(Map.get(params, "week_from"))
    |> fetch_week_to(Map.get(params, "week_to"))
    |> fetch_health_region(Map.get(params, "health_region"))
    |> fetch_city(Map.get(params, "city"))
    |> fetch_morbidity(Map.get(params, "morbidity"))
  end

  defp fetch_year_from(socket, year_from) do
    options =
      @current_year
      |> Range.new(@minimum_year)
      |> Enum.to_list()

    data = [
      year_from: parse_integer(year_from, @current_year, options),
      year_from_options: Enum.zip(options, options)
    ]

    assign(socket, data)
  end

  defp fetch_year_to(%{assigns: assigns} = socket, year_to) do
    options =
      @current_year
      |> Range.new(Map.get(assigns, :year_from, @minimum_year))
      |> Enum.to_list()

    data = [
      year_to: parse_integer(year_to, @current_year, options),
      year_to_options: Enum.zip(options, options)
    ]

    assign(socket, data)
  end

  defp fetch_week_from(socket, week_from) do
    options =
      @minimum_week
      |> Range.new(@maximum_week)
      |> Enum.to_list()

    data = [
      week_from: parse_integer(week_from, @minimum_week, options),
      week_from_options: Enum.zip(options, options)
    ]

    assign(socket, data)
  end

  defp fetch_week_to(%{assigns: assigns} = socket, week_to) do
    options =
      assigns
      |> Map.get(:week_from, @minimum_week)
      |> Range.new(@maximum_week)
      |> Enum.to_list()

    data = [
      week_to: parse_integer(week_to, @maximum_week, options),
      week_to_options: Enum.zip(options, options)
    ]

    assign(socket, data)
  end

  defp fetch_health_region(%{assigns: assigns} = socket, health_region_id) do
    health_region_id = parse_integer(health_region_id)

    options =
      assigns
      |> Map.get(:state, %{})
      |> Map.get(:id, @state_id)
      |> Geo.HealthRegions.list_by_state()

    data = [
      health_region: Enum.find(options, &(&1.id == health_region_id)),
      health_region_id: health_region_id,
      health_region_options: Enum.map(options, fn data -> {data.name, data.id} end)
    ]

    assign(socket, data)
  end

  defp fetch_city(%{assigns: assigns} = socket, city_id) do
    city_id = parse_integer(city_id)

    options =
      case assigns do
        %{health_region: %{id: id}} -> Geo.Cities.list_by_health_region(id)
        %{state: %{id: id}} -> Geo.Cities.list_by_state(id)
      end

    options = Enum.sort(options, &(&1.name <= &2.name))

    cities_ids =
      case {city_id, options} do
        {nil, options} -> Enum.map(options, & &1.id)
        {id, _options} -> [id]
      end

    data = [
      cities_ids: cities_ids,
      city: Enum.find(options, &(&1.id == city_id)),
      city_id: city_id,
      city_options: Enum.map(options, fn data -> {data.name, data.id} end)
    ]

    assign(socket, data)
  end

  defp fetch_morbidity(socket, morbidity_id) do
    options = [
      {"Acidentes com animais peçonhetos", "X20,X21,X22,X23,X24,X25,X26,X27,X29"},
      {"Cólera", "A00"},
      {"Coqueluche", "A37"},
      {"Dengue", "A90,A91"},
      {"Difteria", "A36"},
      {"Doença meningocócica", "A39"},
      {"Febre amarela, silvestre e urbana", "A95"},
      {"Febre hemorrágica da dengue", "A91"},
      {"Hanseníase", "A30"},
      {"Hepatite aguda C", "B17.1"},
      {"Hepatite B", "B16"},
      {"HIV/AIDS", "B20,B21,B22,B23,B24"},
      {"Leishmaniose tegumentar americana", "B55.1,B55.2"},
      {"Leishmaniose visceral", "B55.0"},
      {"Leptospirosis", "A27"},
      {"Malária", "B50,B51,B52,B53,B54"},
      {"Meningite", "A17.0,A39.0,A87,G00,G01,G02,G03"},
      {"Mordedura provocada por cão", "W54"},
      {"Rubéola", "B06"},
      {"Sarampo", "B05"},
      {"Sífilis congênita em menores de 1 ano de idade", "A50"},
      {"Síndrome da rubéola congênita", "P35.0"},
      {"Tétano neonatal", "A33"},
      {"Tétano, exceto o tétano neonatal", "A34"},
      {"Tuberculose", "A15,A16,A17,A18,A19"}
    ]

    data = [
      morbidity: Enum.find(options, fn {_name, id} -> id == morbidity_id end),
      morbidity_id: morbidity_id || @default_morbidity_id,
      morbidity_options: options
    ]

    assign(socket, data)
  end

  defp fetch_demographic_data(%{assigns: assigns} = socket) do
    year = Map.get(assigns, :year_to)

    %{total: population} =
      assigns
      |> Map.get(:cities_ids, [])
      |> Consolidations.CitiesYearPopulation.list_by_cities_and_year(year)
      |> Enum.reduce(%Consolidations.CityYearPopulation{}, &Consolidations.CitiesYearPopulation.add/2)

    assign(socket, :population, population)
  end

  defp fetch_birth_data(%{assigns: assigns} = socket) do
    period = Map.take(assigns, [:year_from, :year_to])

    cities_ids = Map.get(assigns, :cities_ids, [])

    births = Registries.BirthRegistries.list_by_cities_and_period(cities_ids, period)

    period =
      case period do
        %{year_to: 2018} -> %{year_from: 2018, year_to: 2018}
        _period -> %{year_from: 2019, year_to: 2019}
      end

    coverage_births = Registries.BirthRegistries.list_by_cities_and_period(cities_ids, period)

    assign(socket, births: Enum.count(births), coverage_births: Enum.count(coverage_births))
  end

  defp fetch_vaccine_coverage_data(%{assigns: assigns} = socket) do
    period = Map.take(assigns, [:year_from, :year_to])

    %{total: penta_vaccinations} =
      assigns
      |> Map.get(:cities_ids, [])
      |> Consolidations.PentaYearCoverages.list_by_cities_and_period(period)
      |> Enum.reduce(%Consolidations.CityYearPopulation{}, &Consolidations.PentaYearCoverages.add/2)

    data = [
      penta_vaccinations: penta_vaccinations,
      penta_coverage: get_penta_coverage(penta_vaccinations, Map.get(assigns, :coverage_births, 0))
    ]

    assign(socket, data)
  end

  defp get_penta_coverage(_vaccinations, 0), do: 0
  defp get_penta_coverage(vaccinations, births), do: round(vaccinations / births * 100.0)

  defp fetch_morbidity_data(%{assigns: assigns} = socket) do
    period = Map.take(assigns, [:week_from, :week_to])

    registries =
      assigns
      |> Map.get(:cities_ids, [])
      |> Registries.MorbidityRegistries.list_by_cities_and_period(period)

    registries_2018 = Enum.filter(registries, &(&1.year == 2018))
    registries_2019 = Enum.filter(registries, &(&1.year == 2019))
    registries_2020 = Enum.filter(registries, &(&1.year == 2020))

    period_registries =
      case assigns do
        %{year_from: nil, year_to: nil} -> registries
        %{year_from: from, year_to: nil} -> Enum.filter(registries, &(&1.year >= from))
        %{year_from: nil, year_to: to} -> Enum.filter(registries, &(&1.year <= to))
        %{year_from: from, year_to: to} -> Enum.filter(registries, &(&1.year >= from and &1.year <= to))
        _ -> registries
      end

    morbidity_options = Map.get(assigns, :morbidity_options, [])
    population = Map.get(assigns, :population, 1)

    morbidities =
      Enum.map(
        morbidity_options,
        &add_data_to_morbidity(&1, registries_2018, registries_2019, registries_2020, period_registries, population)
      )

    morbidity_data = parse_icd_10_data_from_morbidity(%{id: Map.get(assigns, :morbidity_id, @default_morbidity_id)})
    diseases = Map.get(morbidity_data, :diseases)
    sub_diseases = Map.get(morbidity_data, :sub_diseases)

    city_options = Map.get(assigns, :city_options, [])
    cities_ids = Enum.map(city_options, &elem(&1, 1))

    city_populations =
      Consolidations.CitiesYearPopulation.list_by_cities_and_year(
        cities_ids,
        Map.get(assigns, :year_to, @current_year)
      )

    cities_with_population = Enum.zip(city_options, city_populations)

    period = Map.take(assigns, [:year_to, :week_from, :week_to])

    general_registries =
      city_options
      |> Enum.map(fn {_name, id} -> id end)
      |> Registries.MorbidityRegistries.list_by_cities_and_period(period)

    selected_morbidity_registries = filter_registries_by_morbidity(general_registries, diseases, sub_diseases)

    cities_morbidity =
      cities_with_population
      |> Enum.reduce({[], selected_morbidity_registries}, &add_morbidity_data_to_city/2)
      |> elem(0)
      |> Enum.reverse()

    {cities_morbidity, cities_morbidity_legend} = generate_cities_morbidity_legend(cities_morbidity)

    {table_morbidities, _registries} =
      Enum.reduce(
        cities_with_population,
        {[], general_registries},
        fn {{name, id}, population}, {table_data, registries} ->
          {city_registries, registries} = Enum.split_with(registries, &(&1.city_id == id))

          {
            [
              %{
                id: id,
                name: name,
                morbidities:
                  Enum.map(@table_morbidities, fn {m_name, m_id} ->
                    morbidity = parse_icd_10_data_from_morbidity(%{id: m_id, name: m_name})
                    diseases = Map.get(morbidity, :diseases)
                    sub_diseases = Map.get(morbidity, :sub_diseases)

                    morbidity_registries = filter_registries_by_morbidity(city_registries, diseases, sub_diseases)

                    {[%{incidence: incidence, ratio: ratio}], _registries} =
                      add_morbidity_data_to_city({{name, id}, population}, {[], morbidity_registries})

                    %{
                      id: m_id,
                      name: m_name,
                      incidence: incidence,
                      ratio: ratio
                    }
                  end)
              }
            ] ++ table_data,
            registries
          }
        end
      )

    table_morbidities = Enum.reverse(table_morbidities)

    ratios_groups =
      Enum.reduce(table_morbidities, [[], [], [], [], [], []], fn %{morbidities: morbidities}, ratios_groups ->
        Enum.map(Enum.zip(morbidities, ratios_groups), fn {%{ratio: ratio}, ratios} ->
          if ratio == 0 do
            ratios
          else
            [ratio] ++ ratios
          end
        end)
        |> Enum.reverse()
      end)

    colors_groups =
      Enum.map(ratios_groups, fn ratios ->
        if Enum.any?(ratios) do
          {
            {0, "#CCC"},
            {round(Statistics.percentile(ratios, 25)), "#429E44"},
            {round(Statistics.percentile(ratios, 50)), "#C7C92E"},
            {round(Statistics.percentile(ratios, 75)), "#E07726"},
            "#C92E2E"
          }
        else
          {
            {0, "#CCC"},
            {0, "#429E44"},
            {0, "#C7C92E"},
            {0, "#E07726"},
            "#C92E2E"
          }
        end
      end)

    table_morbidities =
      Enum.map(table_morbidities, fn %{morbidities: morbidities} = table_item ->
        morbidities =
          morbidities
          |> Enum.zip(colors_groups)
          |> Enum.map(fn {%{ratio: ratio} = morbidity, {{q0, c0}, {q1, c1}, {q2, c2}, {q3, c3}, c4}} ->
            color =
              cond do
                ratio > q0 and ratio <= q1 -> c1
                ratio > q1 and ratio <= q2 -> c2
                ratio > q2 and ratio <= q3 -> c3
                ratio > q3 -> c4
                true -> c0
              end

            Map.put(morbidity, :color, color)
          end)

        Map.put(table_item, :morbidities, morbidities)
      end)

    data = [
      table_data: table_morbidities,
      table_morbidities: @table_morbidities,
      morbidities: Enum.sort(morbidities, &(&1.incidence_from_period >= &2.incidence_from_period)),
      cities_morbidity: cities_morbidity,
      cities_morbidity_legend: cities_morbidity_legend
    ]

    assign(socket, data)
  end

  defp add_data_to_morbidity({name, id}, r_2018, r_2019, r_2020, r_period, population) do
    %{name: name, id: id, color: "#" <> ColourHash.hex(id)}
    |> parse_icd_10_data_from_morbidity()
    |> count_morbidity_year_data(r_2018, r_2019, r_2020, r_period, population)
  end

  defp parse_icd_10_data_from_morbidity(%{id: id} = morbidity) do
    id
    |> String.split(",")
    |> Enum.reduce(morbidity, &parse_icd_10_id/2)
  end

  defp parse_icd_10_id(id, morbidity) do
    cond do
      String.contains?(id, "-") -> Map.update(morbidity, :blocks, [id], &([id] ++ &1))
      String.contains?(id, ".") -> Map.update(morbidity, :sub_diseases, [id], &([id] ++ &1))
      true -> Map.update(morbidity, :diseases, [id], &([id] ++ &1))
    end
  end

  defp count_morbidity_year_data(morbidity, r_2018, r_2019, r_2020, r_period, population) do
    diseases = Map.get(morbidity, :diseases)
    sub_diseases = Map.get(morbidity, :sub_diseases)

    i_2018 = count_incidences(diseases, sub_diseases, r_2018)
    i_2019 = count_incidences(diseases, sub_diseases, r_2019)
    i_2020 = count_incidences(diseases, sub_diseases, r_2020)
    i_period = count_incidences(diseases, sub_diseases, r_period)

    r_2018 = round(i_2018 / population * 100_000)
    r_2019 = round(i_2019 / population * 100_000)
    r_2020 = round(i_2020 / population * 100_000)
    r_period = round(i_period / population * 100_000)

    morbidity
    |> Map.put(:incidences_per_year, [i_2018, i_2019, i_2020])
    |> Map.put(:incidence_from_period, i_period)
    |> Map.put(:ratios_per_year, [r_2018, r_2019, r_2020])
    |> Map.put(:ratio_from_period, r_period)
  end

  defp count_incidences(diseases, sub_diseases, registries) do
    case {diseases, sub_diseases} do
      {d_ids, nil} -> Enum.count(registries, &(&1.disease_id in d_ids))
      {nil, sd_ids} -> Enum.count(registries, &(&1.sub_disease_id in sd_ids))
      {d_ids, sd_ids} -> Enum.count(registries, &(&1.disease_id in d_ids or &1.sub_disease_id in sd_ids))
    end
  end

  defp filter_registries_by_morbidity(registries, diseases, sub_diseases) do
    case {diseases, sub_diseases} do
      {d_ids, nil} -> Enum.filter(registries, &(&1.disease_id in d_ids))
      {nil, sd_ids} -> Enum.filter(registries, &(&1.sub_disease_id in sd_ids))
      {d_ids, sd_ids} -> Enum.filter(registries, &(&1.disease_id in d_ids or &1.sub_disease_id in sd_ids))
    end
  end

  defp add_morbidity_data_to_city({{_name, city_id}, %{total: population}}, {cities, registries}) do
    {city_registries, registries} = Enum.split_with(registries, &(&1.city_id == city_id))

    incidence = Enum.count(city_registries)
    ratio = round(incidence / population * 100_000)

    {[%{id: city_id, incidence: incidence, ratio: ratio}] ++ cities, registries}
  end

  defp generate_cities_morbidity_legend(cities_morbidity) do
    cities_ratio =
      cities_morbidity
      |> Enum.map(& &1.ratio)
      |> Enum.reject(&(&1 == 0))

    if Enum.any?(cities_ratio) do
      q0 = 0
      q1 = round(Statistics.percentile(cities_ratio, 20))
      q2 = round(Statistics.percentile(cities_ratio, 40))
      q3 = round(Statistics.percentile(cities_ratio, 60))
      q4 = round(Statistics.percentile(cities_ratio, 80))

      cities_morbidity =
        Enum.map(cities_morbidity, fn city_morbidity ->
          ratio = Map.get(city_morbidity, :ratio, 0)

          color =
            cond do
              ratio > q0 and ratio <= q1 -> "#228B22"
              ratio > q1 and ratio <= q2 -> "#CCCC00"
              ratio > q2 and ratio <= q3 -> "#FF8C00"
              ratio > q3 and ratio <= q4 -> "#FF4500"
              ratio > q4 -> "#B22222"
              true -> "#555555"
            end

          Map.put(city_morbidity, :color, color)
        end)

      legend = [
        %{label: get_label(q0, nil), color: "#555555"},
        %{label: get_label(q0, q1), color: "#228B22"},
        %{label: get_label(q1, q2), color: "#CCCC00"},
        %{label: get_label(q2, q3), color: "#FF8C00"},
        %{label: get_label(q3, q4), color: "#FF4500"},
        %{label: get_label(nil, q4), color: "#B22222"}
      ]

      {cities_morbidity, legend}
    else
      {Enum.map(cities_morbidity, &Map.put(&1, :color, "#555555")), [%{label: get_label(0, nil), color: "#555555"}]}
    end
  end

  defp get_label(from, to) do
    case {from, to} do
      {from, nil} -> to_string(from)
      {nil, 0} -> "N/A"
      {nil, to} -> "#{to + 1}+"
      {from, from} -> "N/A"
      {from, to} when from > to -> "N/A"
      {from, to} -> "#{from + 1}-#{to}"
    end
  end

  defp fetch_death_data(%{assigns: assigns} = socket) do
    year = Map.get(assigns, :year_to, @current_year)

    city_options = Map.get(assigns, :city_options, [])

    registries =
      city_options
      |> Enum.map(fn {_name, id} -> id end)
      |> Registries.DeathRegistries.list_by_cities_and_year(year)

    cities_chapters_death_ratios =
      city_options
      |> Enum.reduce({[], registries}, &fetch_city_chapters_death_ratios/2)
      |> elem(0)
      |> Enum.reverse()

    death_chart_datasets =
      @chapters_names
      |> Enum.reduce({[], cities_chapters_death_ratios}, &extract_cities_death_ratios_per_chapter/2)
      |> elem(0)
      |> Enum.reverse()

    assign(socket, :death_chart_datasets, death_chart_datasets)
  end

  defp fetch_city_chapters_death_ratios({city_name, city_id}, {cities_ratios, registries}) do
    {city_registries, registries} = Enum.split_with(registries, &(&1.city_id == city_id))

    deaths = Enum.count(city_registries)

    chapters_ratios =
      if deaths != 0 do
        @chapters_ids
        |> Enum.reduce({[], city_registries}, &fetch_chapters_ratios(&1, &2, deaths))
        |> elem(0)
        |> add_unknown_chapter_deaths(deaths)
        |> Enum.reverse()
      else
        Enum.map(@chapters_ids, fn _chapter_ids -> %{deaths: 0, ratio: 0} end)
      end

    {[%{name: city_name, id: city_id, chapters: chapters_ratios, deaths: deaths}] ++ cities_ratios, registries}
  end

  defp fetch_chapters_ratios(ids, {chapters_ratios, registries}, total_deaths) do
    {chapter_registries, registries} = Enum.split_with(registries, &death_registry_in_disease_ids?(&1, ids))

    deaths = Enum.count(chapter_registries)

    ratio = round(deaths / total_deaths * 100)

    {[%{deaths: deaths, ratio: ratio}] ++ chapters_ratios, registries}
  end

  defp death_registry_in_disease_ids?(%{disease_id: disease_id}, ids) do
    {group, id} = String.split_at(disease_id, 1)
    id = String.to_integer(id)

    Enum.any?(ids, &disease_groups_and_ids_are_equivalents?(&1, {group, id}))
  end

  defp disease_groups_and_ids_are_equivalents?({group, nil}, {group, _id}), do: true
  defp disease_groups_and_ids_are_equivalents?({group, {from, to}}, {group, id}), do: id >= from and id <= to
  defp disease_groups_and_ids_are_equivalents?(_group_and_ids_1, _groups_and_ids_2), do: false

  defp add_unknown_chapter_deaths(chapters_data, total_deaths) do
    data =
      Enum.reduce(
        chapters_data,
        %{deaths: total_deaths, ratio: 100},
        fn d1, d2 -> %{deaths: d2.deaths - d1.deaths, ratio: d2.ratio - d1.ratio} end
      )

    [data] ++ chapters_data
  end

  defp extract_cities_death_ratios_per_chapter(chapter_name, {death_ratios, cities_death_ratios}) do
    color = "#" <> ColourHash.hex(chapter_name)

    {data, cities_death_ratios} = Enum.reduce(cities_death_ratios, {[], []}, &extract_ratio/2)

    data = Enum.reverse(data)
    cities_death_ratios = Enum.reverse(cities_death_ratios)

    death_ratios = [%{label: chapter_name, backgroundColor: color, borderColor: color, data: data}] ++ death_ratios

    {death_ratios, cities_death_ratios}
  end

  defp extract_ratio(city_death_ratios, {ratios, cities_death_ratios}) do
    %{chapters: [%{ratio: ratio} | chapters]} = city_death_ratios
    {[ratio] ++ ratios, [Map.put(city_death_ratios, :chapters, chapters)] ++ cities_death_ratios}
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
