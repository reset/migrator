defmodule Migrator.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  import Migrator, only: [configuration: 0]

  def conf do
    parse_url configuration[:connection]
  end
end
