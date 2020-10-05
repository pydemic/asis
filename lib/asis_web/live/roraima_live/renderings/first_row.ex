defmodule AsisWeb.RoraimaLive.Renderings.FirstRow do
  @moduledoc """
  Render the dashboard first row data.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias Phoenix.LiveView

  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div class="uk-grid uk-grid-small uk-grid-match uk-text-center uk-margin-left uk-margin-right" uk-grid>
      <%= population_card assigns %>
      <%= births_card assigns %>
      <%= first_incidence_card assigns %>
      <%= second_incidence_card assigns %>
      <%= vaccine_coverage_card assigns %>
    </div>
    """
  end

  defp population_card(assigns) do
    value = Map.get(assigns, :population, "N/A")

    default_tooltip = "População residente"

    location_tooltip =
      case assigns do
        %{city: %{name: name}} -> " do município de #{name}"
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    year_tooltip =
      case assigns do
        %{year_to: year} when not is_nil(year) -> " no ano de #{year}"
        _ -> ""
      end

    tooltip = default_tooltip <> location_tooltip <> year_tooltip

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title">População</h3>
        </div>

        <div class="uk-card-body">
          <h2><%= value %></h2>
        </div>
      </div>
    </div>
    """
  end

  defp births_card(assigns) do
    value = Map.get(assigns, :births, "N/A")

    default_tooltip = "Registros de nascimentos"

    location_tooltip =
      case assigns do
        %{city: %{name: name}} -> " do município de #{name}"
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    period_tooltip =
      case assigns do
        %{year_from: year, year_to: year} when not is_nil(year) ->
          " no ano de #{year}"

        %{year_from: from, year_to: to} when not is_nil(from) and not is_nil(to) ->
          " no período de #{from} até #{to}"

        _ ->
          ""
      end

    tooltip = default_tooltip <> location_tooltip <> period_tooltip

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title">Nascimentos</h3>
        </div>

        <div class="uk-card-body">
          <h2><%= value %></h2>
        </div>
      </div>
    </div>
    """
  end

  defp first_incidence_card(assigns) do
    %{name: name, incidence_from_period: incidence, ratio_from_period: ratio} =
      assigns
      |> Map.get(:morbidities, [])
      |> Enum.at(0, %{name: "N/A", incidence_from_period: "N/A", ratio_from_period: "N/A"})

    default_tooltip = "Doença ou agravo de maior incidência"

    location_tooltip =
      case assigns do
        %{city: %{name: name}} -> " do município de #{name}"
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    year_period_tooltip =
      case assigns do
        %{year_from: year, year_to: year} when not is_nil(year) ->
          " no ano de #{year}"

        %{year_from: from, year_to: to} when not is_nil(from) and not is_nil(to) ->
          " no período de #{from} até #{to}"

        _ ->
          ""
      end

    week_period_tooltip =
      case assigns do
        %{week_from: 1, week_to: 53} ->
          ""

        %{week_from: week, week_to: week} when not is_nil(week) ->
          " na #{week}ª semana epidemiológica"

        %{week_from: from, week_to: to} when not is_nil(from) and not is_nil(to) ->
          " entre as semanas epidemiológicas #{from} e #{to}"

        _ ->
          ""
      end

    tooltip = default_tooltip <> location_tooltip <> year_period_tooltip <> week_period_tooltip

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-truncate"><%= name %></h3>
        </div>

        <div class="uk-card-body" uk-tooltip="Taxa de Incidência de <%= name %> é <%= ratio %>">
          <h2><%= incidence %></h2>
        </div>
      </div>
    </div>
    """
  end

  defp second_incidence_card(assigns) do
    %{name: name, incidence_from_period: incidence, ratio_from_period: ratio} =
      assigns
      |> Map.get(:morbidities, [])
      |> Enum.at(1, %{name: "N/A", incidence_from_period: "N/A", ratio_from_period: "N/A"})

    default_tooltip = "Segunda doença ou agravo de maior incidência"

    location_tooltip =
      case assigns do
        %{city: %{name: name}} -> " do município de #{name}"
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    year_period_tooltip =
      case assigns do
        %{year_from: year, year_to: year} when not is_nil(year) ->
          " no ano de #{year}"

        %{year_from: from, year_to: to} when not is_nil(from) and not is_nil(to) ->
          " no período de #{from} até #{to}"

        _ ->
          ""
      end

    week_period_tooltip =
      case assigns do
        %{week_from: 1, week_to: 53} ->
          ""

        %{week_from: week, week_to: week} when not is_nil(week) ->
          " na #{week}ª semana epidemiológica"

        %{week_from: from, week_to: to} when not is_nil(from) and not is_nil(to) ->
          " entre as semanas epidemiológicas #{from} e #{to}"

        _ ->
          ""
      end

    tooltip = default_tooltip <> location_tooltip <> year_period_tooltip <> week_period_tooltip

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-truncate"><%= name %></h3>
        </div>

        <div class="uk-card-body" uk-tooltip="Taxa de Incidência de <%= name %> é <%= ratio %>">
          <h2><%= incidence %></h2>
        </div>
      </div>
    </div>
    """
  end

  defp vaccine_coverage_card(assigns) do
    vaccinations = Map.get(assigns, :penta_vaccinations, "N/A")
    coverage = Map.get(assigns, :penta_coverage, "N/A")

    default_tooltip =
      "Quantidade de aplicação da 3ª dose de pentavalente em crianças menores de 1 ano dividido" <>
        " por total de crianças menores de 1 ano multiplicado por 100"

    location_tooltip =
      case assigns do
        %{city: %{name: name}} -> " do município de #{name}"
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    year_tooltip =
      case assigns do
        %{year_to: year} when not is_nil(year) -> " no ano de #{year}"
        _ -> ""
      end

    tooltip = default_tooltip <> location_tooltip <> year_tooltip

    ~L"""
    <div class="uk-width-1-5@l">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title">Pentavalente</h3>
        </div>

        <div class="uk-card-body" uk-tooltip="<%= vaccinations %> aplicações">
          <h2><%= coverage %> %</h2>
        </div>
      </div>
    </div>
    """
  end
end
