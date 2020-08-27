defmodule AsisWeb.Router do
  @moduledoc """
  Phoenix web routing.
  """

  use AsisWeb, :router
  use Kaffy.Routes, scope: "/admin"
  import Phoenix.LiveDashboard.Router

  pipeline :live_dashboard_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/" do
    get "/", KaffyWeb.HomeController, :index
  end

  scope "/system" do
    pipe_through :live_dashboard_browser
    live_dashboard "/dashboard", metrics: AsisWeb.Telemetry
  end
end
