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

  defp year_period(%{params: params} = assigns) do
    %{year_from: from, year_from_options: from_options, year_to: to, year_to_options: to_options} = params

    from_options = Enum.zip(from_options, from_options)
    to_options = Enum.zip(to_options, to_options)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Ano</a>

          <div class="uk-accordion-content">
            <div class="uk-grid uk-grid-small uk-grid-match" uk-grid>
              <div class="uk-width-1-2@m">
                <%= select assigns, "year_from", from_options, from %>
              </div>

              <div class="uk-width-1-2@m">
                <%= select assigns, "year_to", to_options, to %>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp week_period(%{params: params} = assigns) do
    %{week_from: from, week_from_options: from_options, week_to: to, week_to_options: to_options} = params

    from_options = Enum.zip(from_options, from_options)
    to_options = Enum.zip(to_options, to_options)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Semana Epidemiológica</a>

          <div class="uk-accordion-content">
            <div class="uk-grid uk-grid-small uk-grid-match" uk-grid>
              <div class="uk-width-1-2@m">
                <%= select assigns, "week_from", from_options, from %>
              </div>

              <div class="uk-width-1-2@m">
                <%= select assigns, "week_to", to_options, to %>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp health_region(%{params: params} = assigns) do
    %{health_region_options: options, health_region_id: id} = params

    options = [{"Não escolhida", nil}] ++ Enum.map(options, fn %{id: id, name: name} -> {name, id} end)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Região de Saúde</a>

          <div class="uk-accordion-content">
            <%= select assigns, "health_region", options, id %>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp city(%{params: params} = assigns) do
    %{city_options: options, city_id: id} = params

    options = [{"Não escolhido", nil}] ++ Enum.map(options, fn %{id: id, name: name} -> {name, id} end)

    ~L"""
    <div class="uk-width-1-5@l uk-width-1-2@m">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Município</a>

          <div class="uk-accordion-content">
            <%= select assigns, "city", options, id %>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp morbidity(%{params: params} = assigns) do
    %{morbidity_options: options, morbidity_id: id} = params

    options = [{"Não escolhida", nil}] ++ Enum.map(options, fn %{id: id, name: name} -> {name, id} end)

    ~L"""
    <div class="uk-width-1-5@l">
      <ul class="uk-accordion" uk-accordion>
        <li class="uk-open">
          <a class="uk-accordion-title" href="#">Doença / Agravo</a>

          <div class="uk-accordion-content">
            <%= select assigns, "morbidity", options, id %>
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
