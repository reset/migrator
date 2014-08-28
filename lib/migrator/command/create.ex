defmodule Migrator.Command.Create do
  use Migrator.Command

  def run(args) do
    connection = parse_args(args)
    Migrator.configure(connection: connection)
    Migrator.Repo.start_link
    case Ecto.Storage.up(Migrator.Repo) do
      :ok -> :ok
      {:error, message} ->
        IO.write message
        System.halt(1)
    end
  end

  #
  # Private
  #

  defp display_help do
    IO.write """
    Usage: migrator create CONNECTION-STRING [options]
        -h, --help     show this help
    """
  end

  defp parse_args({[help: true], _, _}) do
    display_help
    System.halt(0)
  end
  defp parse_args(args) when length(args) == 0 do
    display_help
    System.halt(0)
  end
  defp parse_args([connection | _]) do
    connection
  end
end
