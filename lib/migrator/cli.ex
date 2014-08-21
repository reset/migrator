defmodule Migrator.CLI do
  import Migrator, only: [configuration: 0]

  def main(args) do
    [{path, connection}, opts] = parse_args(args)
    Migrator.configure(migrations_path: path, connection: connection)

    unless opts[:to] || opts[:step] || opts[:all] do
      opts = Keyword.put(opts, :all, true)
    end

    Migrator.Repo.start_link
    Ecto.Migrator.run(Migrator.Repo, configuration[:migrations_path], :up, opts)
  end

  #
  # Private
  #

  defp parse_args({[help: true], _, _}) do
    display_help
    System.halt(0)
  end
  defp parse_args({[version: true], _, _}) do
    IO.puts version
    System.halt(0)
  end
  defp parse_args({_, argv, _}) when length(argv) == 0 do
    display_help
    System.halt(0)
  end
  defp parse_args({_, argv, _}) when length(argv) < 2 do
    IO.puts "Invalid number of arguments. Specify both a path and connection string."
    display_help
    System.halt(1)
  end
  defp parse_args({options, [path, connection | _], []}) do
    [{path, connection}, options]
  end
  defp parse_args(args) do
    OptionParser.parse(args, [
      switches: [all: :boolean, step: :integer, to: :integer, version: :boolean, help: :boolean],
      aliases: [n: :step, t: :to, v: :version, h: :help]
    ]) |> parse_args
  end

  defp display_help do
    IO.write """
    Usage: migrator path connection-string [options]
        -h, --help     show this help
        -v, --version  show the version
    """
  end

  defp version do
    {:ok, vsn} = :application.get_key(:migrator, :vsn)
    vsn
  end
end
