defmodule ExState.MixProject do
  use Mix.Project

  @version "2.0.1"

  def project do
    [
      app: :ex_state,
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_apps: [:mix],
        plt_add_deps: :transitive,
        ignore_warnings: "dialyzer.ignore-warnings",
        flags: [
          :unmatched_returns,
          :error_handling,
          :race_conditions,
          :no_opaque
        ]
      ],
      version: @version,
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description:
        "A library for creating, interpreting, and executing finite state machines and statecharts.",
      deps: deps(),
      docs: docs(),
      source_url: "https://github.com/catchcake/ex_state",
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev},
      {:credo, "~> 1.1", only: [:dev, :test]},
      {:excoveralls, "~> 0.11", only: :test},
      {:dialyxir, "~> 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: [
        "Jindrich K. Smitka <smitka.j@gmail.com>",
        "Ondrej Tucek <ondrej.tucek@gmail.com>",
        "Daniel Bultas <comm3net@gmail.com>"
      ],
      licenses: ["BSD-4-Clause"],
      links: %{
        "GitHub" => "https://github.com/iodevs/ex_state"
      }
    ]
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      main: "getting_started",
      extra_section: "GUIDES",
      assets: "guides/assets",
      extras: extras(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp extras() do
    [
      "guides/getting_started.md",
      "guides/events.md",
      "guides/machines.md",
      "guides/states.md",
      "guides/statenodes.md",
      "guides/transitions.md",
      "guides/hierarchical.md",
      "guides/history.md",
      "guides/parallel.md"
    ]
  end

  defp groups_for_extras() do
    [
      Guides: ~r/guides\/[^\/]+\.md/
    ]
  end
end
