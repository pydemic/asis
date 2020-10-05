defmodule AsisWeb.RoraimaLive.EventManager do
  import Phoenix.LiveView, only: [redirect: 2]
  alias AsisWeb.Router.Helpers, as: Routes

  @spec handle_event(LiveView.Socket.t(), map(), String.t()) :: LiveView.Socket.t()
  def handle_event(socket, params, _event) do
    params =
      params
      |> Map.drop(["_target"])
      |> Enum.reject(fn {_key, value} -> value == "" end)

    redirect(socket, to: Routes.roraima_path(socket, :index, params))
  end
end
