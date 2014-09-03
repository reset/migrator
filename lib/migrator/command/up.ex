defmodule Migrator.Command.Up do
  use Migrator.Command
  import Migrator.CLI, only: [parse_connection_uri: 1]

  def run(args) do
    {path, uri, opts} = parse_args(args)
    conn              = parse_connection_uri(uri)
    Migrator.up(path, conn, opts)
  end

  #
  # Private
  #

  defp display_help do
    IO.write """
    Usage: migrator up PATH CONNECTION-URI [options]
        -s, --schema   set sql schema (default: public)
        -t, --to       run all migrations up to and including version
        -n, --step     run n number of pending migrations
        -a, --all      run all pending migrations (default)
        -h, --help     show this help
    """
  end

  defp parse_args({[help: true], _, _}) do
    display_help
    System.halt(0)
  end
  defp parse_args({_, args, _}) when length(args) == 0 do
    display_help
    System.halt(0)
  end
  defp parse_args({_, args, _}) when length(args) < 2 do
    IO.puts "Invalid number of arguments. Specify both a path and connection string."
    display_help
    System.halt(1)
  end
  defp parse_args({opts, [path, connection| _], _}) do
    {path, connection, opts}
  end
  defp parse_args(args) do
    OptionParser.parse(args, [
      switches: [all: :boolean, step: :integer, to: :integer, version: :boolean, help: :boolean, schema: :binary],
      aliases: [a: :all, n: :step, t: :to, v: :version, h: :help, s: :schema]
    ]) |> parse_args
  end
end
