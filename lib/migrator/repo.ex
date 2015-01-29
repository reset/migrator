defmodule Migrator.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, otp_app: :migrator
  import Migrator, only: [configuration: 0]

  def conf do
    Dict.to_list(configuration[:connection]) ++ [size: "1"]
  end

  def create_schema(name) do
    adapter.query(__MODULE__, "CREATE SCHEMA IF NOT EXISTS #{name}", [])
  end

  def set_schema(nil), do: :ok
  def set_schema(name) do
    create_schema(name)
    adapter.query(__MODULE__, "SET search_path TO #{name}", [])
  end
end
