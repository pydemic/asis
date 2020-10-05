defmodule AsisWeb.RoraimaLive.Renderings.ThirdRow do
  @moduledoc """
  Render the dashboard second row data.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias Phoenix.LiveView

  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div class="uk-grid uk-grid-small uk-grid-match uk-margin-left uk-margin-right" uk-grid>
      <%= incidence_ratio_table_card assigns %>
      <%= death_ratio_chart_card assigns %>
    </div>
    """
  end

  defp incidence_ratio_table_card(assigns) do
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
    <div class="uk-width-1-2@l">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-center">Taxa de Incidência de Municípios</h3>
        </div>

        <div class="uk-card-body uk-overflow-auto">
          <table class="uk-table uk-table-small uk-table-middle uk-text-center uk-text-small">
            <thead>
              <tr>
                <th class="asis-roraima-empty"></th>
                <%= for header <- incidence_ratio_table_headers assigns do %>
                  <%= header %>
                <% end %>
              </tr>
            </thead>
            <tbody>
              <%= for item <- incidence_ratio_table_data assigns do %>
                <%= item %>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  defp incidence_ratio_table_headers(assigns) do
    assigns
    |> Map.get(:table_morbidities, [])
    |> Enum.with_index(1)
    |> Enum.map(fn {{name, _id}, index} ->
      ~L"""
      <th class="uk-text-center" uk-tooltip="<%= name %>">D<%= index %></th>
      """
    end)
  end

  defp incidence_ratio_table_data(assigns) do
    assigns
    |> Map.get(:table_data, [])
    |> Enum.with_index(1)
    |> Enum.map(fn {%{name: name, morbidities: morbidities}, index} ->
      ~L"""
      <tr>
        <td class="uk-text-right" uk-tooltip="<%= name %>">M<%= index %></td>
        <%= for morbidity <- morbidities do %>
        <td class="asis-roraima-table-item" style="background-color: <%= morbidity.color %>" uk-tooltip="Incidência de <%= morbidity.name %> em <%= name %> é <%= morbidity.incidence %>">
          <%= morbidity.ratio %>
        </td>
        <% end %>
      </tr>
      """
    end)
  end

  defp death_ratio_chart_card(assigns) do
    default_tooltip = "Óbitos por capítulo do CID-10 dividido por óbitos totais multiplicado por 100"

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

    tooltip = default_tooltip <> location_tooltip <> year_tooltip

    ~L"""
    <div class="uk-width-1-2@l">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-center">Taxa de Mortalidade por Capítulo CID-10</h3>
        </div>
        <div class="uk-card-body" phx-update="ignore">
          <canvas id="death_ratio_chart" height="350"></canvas>
        </div>
      </div>
    </div>
    """
  end
end
