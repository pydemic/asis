defmodule AsisWeb.RoraimaLive do
  @moduledoc """
  Live controller for Roraima dashboard.
  """

  use Phoenix.LiveView, layout: {AsisWeb.LayoutView, "live.html"}
  require Logger
  alias AsisWeb.RoraimaLive.{DataManager, EventManager, RenderManager}
  alias Phoenix.LiveView

  @impl Phoenix.LiveView
  @spec mount(map(), map(), LiveView.Socket.t()) :: {:ok, LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  @spec handle_params(map(), String.t(), LiveView.Socket.t()) :: {:noreply, LiveView.Socket.t()}
  def handle_params(params, _url, socket) do
    {:noreply, DataManager.update(socket, params)}
  end

  @impl Phoenix.LiveView
  @spec handle_event(String.t(), map(), LiveView.Socket.t()) :: {:noreply, LiveView.Socket.t()}
  def handle_event(event, params, socket) do
    {:noreply, EventManager.handle_event(socket, params, event)}
  end

  @impl Phoenix.LiveView
  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    RenderManager.render(assigns)
  end
end
