defmodule Migrator.CLI do
  alias Migrator.Command

  def main(args) do
    {command, {args2, opts}} = parse_args(args)
    dispatch(command, args2, opts)
  end

  #
  # Private
  #

  defp dispatch("up", args, opts), do: _dispatch(Command.Up, args, opts)
  defp dispatch("create", args, opts), do: _dispatch(Command.Create, args, opts)
  defp dispatch("drop", args, opts), do: _dispatch(Command.Drop, args, opts)
  defp dispatch(cmd, _, _) do
    IO.puts "Unsupported command: #{cmd}"
    display_help
    System.halt(1)
  end
  defp _dispatch(module, args, opts), do: apply(module, :run, [args, opts])

  defp display_help do
    IO.write """
    Usage: migrator COMMAND [options]
        -h, --help     show this help
        -v, --version  show the version
    """
  end

  defp parse_args({[help: true], _, _}) do
    display_help
    System.halt(0)
  end
  defp parse_args({[version: true], _, _}) do
    IO.puts Migrator.version
    System.halt(0)
  end
  defp parse_args({_, argv, _}) when length(argv) == 0 do
    display_help
    System.halt(0)
  end
  defp parse_args({opts, [command|rest], _}) do
    {command, {rest, opts}}
  end
  defp parse_args(args) do
    OptionParser.parse(args, [
      switches: [all: :boolean, step: :integer, to: :integer, version: :boolean, help: :boolean],
      aliases: [n: :step, t: :to, v: :version, h: :help]
    ]) |> parse_args
  end
end
