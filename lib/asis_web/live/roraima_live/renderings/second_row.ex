defmodule AsisWeb.RoraimaLive.Renderings.SecondRow do
  @moduledoc """
  Render the dashboard second row data.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias Phoenix.LiveView

  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div class="uk-grid uk-grid-small uk-grid-match uk-margin-left uk-margin-right" uk-grid>
      <%= incidence_ratio_chart_card assigns %>
      <%= incidence_chart_card assigns %>
      <%= incidence_ratio_map_card assigns %>
    </div>
    """
  end

  defp incidence_ratio_chart_card(assigns) do
    default_tooltip = "Doença ou agravo dividido por população residente multiplicado por 100.000"

    location_tooltip =
      case assigns do
        %{city: %{name: name}} -> " do município de #{name}"
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
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

    tooltip = default_tooltip <> location_tooltip <> week_period_tooltip

    ~L"""
    <div class="uk-width-1-3@l">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-center">Taxa de Incidência</h3>
        </div>

        <div class="uk-card-body" phx-update="ignore">
          <canvas id="incidence_ratio_chart" height="500"></canvas>
        </div>
      </div>
    </div>
    """
  end

  defp incidence_chart_card(assigns) do
    default_tooltip = "Doença ou agravo"

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
    <div class="uk-width-1-3@l">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-center">Incidência</h3>
        </div>

        <div class="uk-card-body" phx-update="ignore">
          <canvas id="incidence_chart" height="500"></canvas>
        </div>
      </div>
    </div>
    """
  end

  defp incidence_ratio_map_card(assigns) do
    default_tooltip = "Doença ou agravo dividido por população residente multiplicado por 100.000"

    location_tooltip =
      case assigns do
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    year_tooltip =
      case assigns do
        %{year_to: year} when not is_nil(year) -> " no ano de #{year}"
        _ -> ""
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

    tooltip = default_tooltip <> location_tooltip <> year_tooltip <> week_period_tooltip

    ~L"""
    <div class="uk-width-1-3@l" uk-tooltip="<%= tooltip %>">
      <div class="uk-card uk-card-hover uk-card-default" phx-update="ignore">
        <div id="incidence_ratio_map" class="uk-card-body uk-height-1-1 asis-roraima-map"></div>
      </div>
    </div>
    """
  end
end
