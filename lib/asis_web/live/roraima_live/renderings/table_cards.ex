defmodule AsisWeb.RoraimaLive.Renderings.TableCards do
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

  defp incidence_ratio_table_card(%{params: params} = assigns) do
    default_tooltip = "Doença ou agravo dividido por população residente multiplicado por 100.000"

    location_tooltip =
      case params do
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    year_tooltip =
      case params do
        %{year_to: year} when not is_nil(year) -> " no ano de #{year}"
        _ -> ""
      end

    week_period_tooltip =
      case params do
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
    <div class="uk-width-1-1">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-center">Taxa de Incidência por Munícipio</h3>
        </div>

        <div class="uk-card-body uk-overflow-auto">
          <table class="uk-table uk-table-small uk-table-middle uk-text-small asis-roraima-table">
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

        <div class="uk-card-footer">
          <div class="uk-grid uk-grid-small uk-grid-match">
            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q0 uk-text-center uk-text-secondary">
                0
              </code>
            </div>

            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q1 uk-text-center uk-text-secondary">
                1%-25%
              </code>
            </div>

            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q2 uk-text-center uk-text-secondary">
                26%-75%
              </code>
            </div>

            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q3 uk-text-center uk-text-secondary">
                76%-100%
              </code>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp incidence_ratio_table_headers(%{morbidity_data: morbidity_data} = assigns) do
    morbidity_data
    |> Map.get(:selected_region_data, %{})
    |> Map.get(:morbidities, [])
    |> Enum.map(fn %{name: name} ->
      ~L"""
      <th class="asis-roraima-table-header asis-roraima-morbidity-table-header uk-text-emphasis">
        <div><span><%= name %></span></div>
      </th>
      """
    end)
  end

  defp incidence_ratio_table_data(%{morbidity_data: morbidity_data} = assigns) do
    morbidity_data
    |> Map.get(:selected_region_data, %{})
    |> Map.get(:incidences, [])
    |> Enum.map(fn %{name: name, colors: colors, ratios: ratios, incidences: incidences} ->
      data = Enum.zip([incidences, ratios, colors])

      ~L"""
      <tr>
        <td class="uk-text-right uk-text-emphasis uk-text-nowrap"><%= name %></td>
        <%= for {incidence, ratio, color} <- data do %>
        <td class="asis-roraima-table-item uk-text-center uk-text-secondary"
            style="background-color: <%= color %>"
            uk-tooltip="Incidência é <%= incidence %>">
          <%= if ratio > 0 do %>
            <%= ratio %>
          <% end %>
        </td>
        <% end %>
      </tr>
      """
    end)
  end

  defp death_ratio_chart_card(%{params: params} = assigns) do
    default_tooltip = "Percentual de óbitos por capítulo da CID-10 dividido por óbitos totais multiplicado por 100"

    location_tooltip =
      case params do
        %{health_region: %{name: name}} -> " da região de saúde #{name}"
        %{state: %{name: name}} -> " do estado de #{name}"
        _ -> ""
      end

    year_tooltip =
      case params do
        %{year_to: year} when not is_nil(year) -> " no ano de #{year}"
        _ -> ""
      end

    tooltip = default_tooltip <> location_tooltip <> year_tooltip

    ~L"""
    <div class="uk-width-1-1">
      <div class="uk-card uk-card-hover uk-card-default">
        <div class="uk-card-header" uk-tooltip="<%= tooltip %>">
          <h3 class="uk-card-title uk-text-center">Percentual de Óbitos por Capítulo da CID-10 por Município</h3>
        </div>

        <div class="uk-card-body uk-overflow-auto">
          <table class="uk-table uk-table-small uk-table-middle uk-text-small asis-roraima-table">
            <thead>
              <tr>
                <th class="asis-roraima-empty"></th>
                <%= for header <- death_ratio_table_headers assigns do %>
                  <%= header %>
                <% end %>
              </tr>
            </thead>
            <tbody>
              <%= for item <- death_ratio_table_data assigns do %>
                <%= item %>
              <% end %>
            </tbody>
          </table>
        </div>

        <div class="uk-card-footer">
          <div class="uk-grid uk-grid-small uk-grid-match">
            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q0 uk-text-center uk-text-secondary">
                0
              </code>
            </div>

            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q1 uk-text-center uk-text-secondary">
                1%-19%
              </code>
            </div>

            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q2 uk-text-center uk-text-secondary">
                20%-39%
              </code>
            </div>

            <div class="uk-width-1-4@m">
              <code class="asis-roraima-label-color asis-roraima-table-q3 uk-text-center uk-text-secondary">
                40%-100%
              </code>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp death_ratio_table_headers(assigns) do
    assigns
    |> Map.get(:death_data, %{})
    |> Map.get(:chapters, [])
    |> Enum.map(fn %{id: id, name: name} ->
      ~L"""
      <th class="uk-text-emphasis" uk-tooltip="<%= name %>">
        <div><span><%= id %></span></div>
      </th>
      """
    end)
  end

  defp death_ratio_table_data(assigns) do
    assigns
    |> Map.get(:death_data, %{})
    |> Map.get(:cities_deaths, [])
    |> Enum.map(fn %{name: name, colors: colors, ratios: ratios, deaths: deaths} ->
      data = Enum.zip([deaths, ratios, colors])

      ~L"""
      <tr>
        <td class="uk-text-right uk-text-emphasis uk-text-nowrap"><%= name %></td>
        <%= for {deaths, ratio, color} <- data do %>
        <td class="asis-roraima-table-item uk-text-center uk-text-secondary"
            style="background-color: <%= color %>"
            uk-tooltip="Quantidade de óbitos é <%= deaths %>">
          <%= if ratio > 0 do %>
            <%= ratio %>
          <% end %>
        </td>
        <% end %>
      </tr>
      """
    end)
  end
end
