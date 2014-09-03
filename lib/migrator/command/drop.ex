defmodule Migrator.Command.Drop do
  use Migrator.Command
  import Migrator.CLI, only: [parse_connection_uri: 1]

  def run(args) do
    uri = parse_args(args)
    case parse_connection_uri(uri) |> Migrator.drop do
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
    Usage: migrator drop CONNECTION-URI [options]
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
