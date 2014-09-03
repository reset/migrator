defmodule Migrator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :migrator,
      version: "0.2.0",
      elixir: "~> 0.15.1 or ~> 1.0.0-rc1",
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
      {:ecto, "~> 0.2.0"},
    ]
  end
end
