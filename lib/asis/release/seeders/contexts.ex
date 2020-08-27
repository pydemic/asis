defmodule Asis.Release.Seeders.Contexts do
  @moduledoc """
  Seed `Asis.Contexts` data.
  """

  @app :asis

  alias Asis.Release.Seeders.Contexts

  @spec seed_all(keyword()) :: :ok
  def seed_all(opts \\ []) do
    maybe_load_app(opts)

    Contexts.ICD10.seed(opts)
    Contexts.Geo.seed(opts)
    Contexts.Registries.seed(opts)
    Contexts.Consolidations.seed(opts)
  end

  defp maybe_load_app(opts) do
    if Keyword.get(opts, :load?, false) == true do
      Application.load(@app)
    end
  end
end
