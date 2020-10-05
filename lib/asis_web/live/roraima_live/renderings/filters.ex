defmodule AsisWeb.RoraimaLive.Renderings.Filters do
  @moduledoc """
  Render the dashboard filters.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias Phoenix.LiveView

  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div class="uk-grid uk-grid-small uk-grid-match uk-margin-left uk-margin-right" uk-grid>
      <div class="uk-width-1-1">
        <ul class="uk-accordion" uk-accordion>
          <li class="uk-open">
            <a class="uk-accordion-title" href="#">Filtros</a>

            <div class="uk-accordion-content">
              <form phx-change="filter">
                <div class="uk-grid uk-grid-small uk-grid-match" uk-grid>
                  <%= year_period assigns %>
                  <%= week_period assigns %>
                  <%= health_region assigns %>
                  <%= city assigns %>
                  <%= morbidity assigns %>
                </div>
              </form>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  defp year_period(assigns) do
    from_options = Map.get(assigns, :year_from_options, [{"Não escolhido", nil}])
    from_default = Map.get(assigns, :year_from)

    to_options = Map.get(assigns, :year_to_options, [{"Não escolhido", nil}])
    to_default = Map.get(assigns, :year_to)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Ano</a>

          <div class="uk-accordion-content">
            <div class="uk-grid uk-grid-small uk-grid-match" uk-grid>
              <div class="uk-width-1-2@m">
                <%= select assigns, "year_from", from_options, from_default %>
              </div>

              <div class="uk-width-1-2@m">
                <%= select assigns, "year_to", to_options, to_default %>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp week_period(assigns) do
    from_options = Map.get(assigns, :week_from_options, [{"Não escolhida", nil}])
    from_default = Map.get(assigns, :week_from)

    to_options = Map.get(assigns, :week_to_options, [{"Não escolhida", nil}])
    to_default = Map.get(assigns, :week_to)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Semana Epidemiológica</a>

          <div class="uk-accordion-content">
            <div class="uk-grid uk-grid-small uk-grid-match" uk-grid>
              <div class="uk-width-1-2@m">
                <%= select assigns, "week_from", from_options, from_default %>
              </div>

              <div class="uk-width-1-2@m">
                <%= select assigns, "week_to", to_options, to_default %>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp health_region(assigns) do
    options = [{"Não escolhida", nil}] ++ Map.get(assigns, :health_region_options, [])
    default = Map.get(assigns, :health_region_id)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Região de Saúde</a>

          <div class="uk-accordion-content">
            <%= select assigns, "health_region", options, default %>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp city(assigns) do
    options = [{"Não escolhido", nil}] ++ Map.get(assigns, :city_options, [])
    default = Map.get(assigns, :city_id)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Município</a>

          <div class="uk-accordion-content">
            <%= select assigns, "city", options, default %>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp morbidity(assigns) do
    options = [{"Não escolhida", nil}] ++ Map.get(assigns, :morbidity_options, [])
    default = Map.get(assigns, :morbidity_id)

    ~L"""
    <div class="uk-width-1-5@l">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Doença / Agravo</a>

          <div class="uk-accordion-content">
            <%= select assigns, "morbidity", options, default %>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp select(assigns, name, options, selected_value) do
    ~L"""
    <select class="uk-select" name="<%= name %>">
      <%= for {name, value} <- options do %>
        <%= if value == selected_value do %>
          <option value="<%= value %>" selected><%= name %></option>
        <% else %>
          <option value="<%= value %>"><%= name %></option>
        <% end %>
      <% end %>
    </select>
    """
  end
end
