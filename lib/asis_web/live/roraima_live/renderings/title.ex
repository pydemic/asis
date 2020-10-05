defmodule AsisWeb.RoraimaLive.Renderings.Title do
  @moduledoc """
  Render the dashboard title.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias Phoenix.LiveView

  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <h2 class="uk-heading-divider uk-margin-left uk-margin-right">
      Painel de <%= location assigns %>
    </h2>
    """
  end

  defp location(assigns) do
    case assigns do
      %{state: %{abbr: state_abbr}, health_region: %{name: health_region_name}, city: %{name: city_name}} ->
        "#{city_name} (#{health_region_name}) - #{state_abbr}"

      %{state: %{abbr: state_abbr}, health_region: %{name: health_region_name}} ->
        "#{health_region_name} - #{state_abbr}"

      %{state: %{abbr: state_abbr}, city: %{name: city_name}} ->
        "#{city_name} - #{state_abbr}"

      %{state: %{name: state_name}} ->
        state_name

      _ ->
        "análise de situação de saúde"
    end
  end
end
