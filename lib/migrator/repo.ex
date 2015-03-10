defmodule Migrator.Repo do
  use Ecto.Repo, otp_app: :migrator

  def create_schema(name) do
    Ecto.Adapters.SQL.query(__MODULE__, "CREATE SCHEMA IF NOT EXISTS #{name}", [])
  end

  def set_schema(nil), do: :ok
  def set_schema(name) do
    create_schema(name)
    Ecto.Adapters.SQL.query(__MODULE__, "SET search_path TO #{name}", [])
  end
end
