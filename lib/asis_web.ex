defmodule AsisWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use AsisWeb, :controller
      use AsisWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  @spec controller :: {:__block__, list(), list()}
  def controller do
    quote do
      use Phoenix.Controller, namespace: AsisWeb

      import Plug.Conn
      import AsisWeb.Gettext
      alias AsisWeb.Router.Helpers, as: Routes
    end
  end

  @spec view :: {:__block__, list(), list()}
  def view do
    quote do
      use Phoenix.View,
        root: "lib/asis_web/templates",
        namespace: AsisWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  @spec live_view :: {:__block__, list(), list()}
  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {AsisWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  @spec live_component :: {:__block__, list(), list()}
  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  @spec router :: {:__block__, list(), list()}
  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  @spec channel :: {:__block__, list(), list()}
  def channel do
    quote do
      use Phoenix.Channel
      import AsisWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers
      import AsisWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import AsisWeb.ErrorHelpers
      import AsisWeb.Gettext
      alias AsisWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  @spec __using__(atom()) :: any()
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
