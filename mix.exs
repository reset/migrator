defmodule Migrator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :migrator,
      version: "0.2.1",
      elixir: "~> 1.0.0 or ~> 0.15.1",
      deps: deps,
      escript: [
        main_module: Migrator.CLI,
      ],
    ]
  end

  def application do
    [
      mod: {Migrator, []},
      applications: [
        :logger,
        :postgrex,
        :ecto,
      ],
      env: [],
    ]
  end

  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.3.0"},
    ]
  end
end
