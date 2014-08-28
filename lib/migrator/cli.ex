defmodule Migrator.CLI do
  alias Migrator.Command

  def main(args) do
    command = parse_args(args)
    dispatch(command, List.delete(args, command))
  end

  #
  # Private
  #

  defp dispatch("up", argv), do: _dispatch(Command.Up, argv)
  defp dispatch("create", argv), do: _dispatch(Command.Create, argv)
  defp dispatch("drop", argv), do: _dispatch(Command.Drop, argv)
  defp dispatch(cmd, _) do
    IO.puts "Unsupported command: #{cmd}"
    display_help
    System.halt(1)
  end
  defp _dispatch(module, argv), do: apply(module, :run, [argv])

  defp display_help do
    IO.write """
    Commands:
        migrator up PATH CONNECTION-STRING [options]
        migrator create CONNECTION-STRING [options]
        migrator drop CONNECTION-STRING [options]

    Options:
        -h, --help     show this help
        -v, --version  show the version
    """
  end

  defp parse_args({[help: true], argv, _}) when length(argv) == 0 do
    display_help
    System.halt(0)
  end
  defp parse_args({[version: true], argv, _}) when length(argv) == 0 do
    IO.puts Migrator.version
    System.halt(0)
  end
  defp parse_args({_, argv, _}) when length(argv) == 0 do
    display_help
    System.halt(0)
  end
  defp parse_args({_, [command|_], _}), do: command
  defp parse_args(args) do
    OptionParser.parse(args, [
      switches: [version: :boolean, help: :boolean],
      aliases: [v: :version, h: :help]
    ]) |> parse_args
  end
end
