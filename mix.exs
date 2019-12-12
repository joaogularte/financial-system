defmodule FinancialSystem.MixProject do
  use Mix.Project

  def project do
    [
      app: :financial_system,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # ExCoveralls - Coverage Test
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # ExDocs
      name: "Financial System",
      source_url: "https://github.com/joaogularte/financial-system",
      homepage_url: "https://github.com/joaogularte/financial-system",
      docs: [main: "FinancialSystem",
            extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.10", only: :test},
      {:tesla, "~> 1.3.0"},
      {:poison, "~> 3.1"},
      {:decimal, "~> 1.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
