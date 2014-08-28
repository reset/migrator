defmodule Migrator.Command.Up do
  use Migrator.Command

  def run(args, opts \\ []) do
    {path, connection} = parse_args(args)
    Migrator.configure(migrations_path: path, connection: connection)

    unless opts[:to] || opts[:step] || opts[:all] do
      opts = Keyword.put(opts, :all, true)
    end

    Migrator.Repo.start_link
    Migrator.Repo.set_schema(opts[:schema])
    Ecto.Migrator.run(Migrator.Repo, configuration[:migrations_path], :up, opts)
  end

  #
  # Private
  #

  defp display_help do
    IO.write """
    Usage: migrator up PATH CONNECTION-STRING [options]
        -s, --schema   set sql schema (default: public)
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
  defp parse_args(args) when length(args) < 2 do
    IO.puts "Invalid number of arguments. Specify both a path and connection string."
    display_help
    System.halt(1)
  end
  defp parse_args([path, connection | _]) do
    {path, connection}
  end
end
