defmodule Migrator.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  import Migrator, only: [configuration: 0]

  def conf do
    opts = parse_url configuration[:connection]
    opts ++ [size: 1]
  end
end
