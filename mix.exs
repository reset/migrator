defmodule Migrator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :migrator,
      version: "0.7.0",
      elixir: "~> 1.0 and ~> 1.0.4",
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
      env: [
        'Elixir.Migrator.Repo': [
          adapter: Ecto.Adapters.Postgres,
        ],
      ],
    ]
  end

  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.13.0"},
    ]
  end
end
