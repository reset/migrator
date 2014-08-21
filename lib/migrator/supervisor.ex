#
# © 2013-2014 Undead Labs, LLC
#

defmodule Migrator.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
    ]

    supervise(children, strategy: :one_for_one)
  end
end
