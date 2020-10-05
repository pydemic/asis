defmodule AsisWeb.RoraimaLive.RenderManager do
  @moduledoc """
  Perform `AsisWeb.RoraimaLive` renderings.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias AsisWeb.RoraimaLive.Renderings
  alias Phoenix.LiveView

  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div class="uk-section uk-section-xsmall uk-section-muted">
      <%= Renderings.Title.render assigns %>
      <%= Renderings.Filters.render assigns %>

      <hr class="uk-margin-left uk-margin-right"/>

      <%= Renderings.FirstRow.render assigns %>
      <%= Renderings.SecondRow.render assigns %>
      <%= Renderings.ThirdRow.render assigns %>
    </div>

    <%= Renderings.JS.render assigns %>
    """
  end
end
