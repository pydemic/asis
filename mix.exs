defmodule Asis.MixProject do
  use Mix.Project

  def project do
    [
      app: :asis,
      version: "0.0.1",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      default_release: :asis,
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: preferred_cli_env(),
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      deps: deps(),
      releases: releases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Asis.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      i18n: ["i18n.extract", "i18n.merge.en_US", "i18n.merge.pt_BR"],
      "i18n.extract": ["gettext.extract"],
      "i18n.merge.en_US": ["gettext.merge priv/gettext --locale en_US"],
      "i18n.merge.pt_BR": ["gettext.merge priv/gettext --locale pt_BR"],
      reseed: ["ecto.reset", "seed"],
      setup: ["update.deps", "ecto.setup"],
      start: ["phx.server"],
      "staging.start": ["ecto.reset", "cmd mix seed", "start"],
      test: ["ecto.setup", "test"],
      "test.all": ["test.static", "test.coverage"],
      "test.ci": ["test.static", "ecto.reset", "coveralls.github"],
      "test.coverage": ["ecto.reset", "coveralls"],
      "test.static": ["format --check-formatted", "credo list --all"],
      "update.deps": ["deps.get", "cmd yarn install --cwd assets"]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:colour_hash, "~> 1.0.3"},
      {:credo, "~> 1.4.0", only: :test, runtime: false},
      {:ecto_sql, "~> 3.4"},
      {:ex_doc, "~> 0.22.2", only: :test, runtime: false},
      {:excoveralls, "~> 0.13.1", only: :test},
      {:floki, ">= 0.0.0", only: :test},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.16.0"},
      {:jason, "~> 1.0"},
      {:kaffy, "~> 0.9.0"},
      {:nimble_csv, "~> 0.7.0"},
      {:phoenix_ecto, "~> 4.2.1"},
      {:phoenix_html, "~> 2.14.2"},
      {:phoenix_live_dashboard, "~> 0.2.9"},
      {:phoenix_live_reload, "~> 1.2.4", only: :dev},
      {:phoenix_live_view, "~> 0.14.7"},
      {:phoenix, "~> 1.5.5"},
      {:plug_cowboy, "~> 2.3.0"},
      {:postgrex, "~> 0.15.6"},
      {:statistics, "~> 0.6.2"},
      {:telemetry_metrics, "~> 0.5.0"},
      {:telemetry_poller, "~> 0.5.1"},
      {:tesla, "~> 1.3.3"}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp preferred_cli_env do
    [
      credo: :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.html": :test,
      "coveralls.post": :test,
      test: :test,
      "test.ci": :test,
      "test.all": :test,
      "test.coverage": :test,
      "test.static": :test
    ]
  end

  defp releases do
    [
      asis: [
        include_erts: false,
        include_executables_for: [:unix]
      ]
    ]
  end
end
