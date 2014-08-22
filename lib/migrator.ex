defmodule Migrator do
  use Application
  import Ecto.Utils, only: [parse_url: 1]

  def configure(options) do
    Enum.each options, fn(option) ->
      config_set(option)
    end
  end

  def configuration do
    Application.get_all_env(:migrator)
  end

  def version do
    {:ok, vsn} = :application.get_key(:migrator, :vsn)
    vsn
  end

  #
  # Application callbacks
  #

  def start(_type, _args) do
    Migrator.Supervisor.start_link
  end

  #
  # Private
  #

  defp config_set({:connection = key, conn}) do
    validate_connection(conn)
    config_set(key, conn)
  end
  defp config_set({:migrations_path = key, path}) do
    path = Path.expand(path)
    validate_path(path)
    config_set(key, path)
  end
  defp config_set(key, value), do: Application.put_env(:migrator, key, value)

  defp validate_connection(conn) do
    try do
      parse_url(conn)
    rescue
      e in Ecto.InvalidURL ->
        IO.puts e.message
        System.halt(1)
    end
  end

  defp validate_path(path) do
    unless File.exists?(path) do
      IO.puts "Path to migrations does not exist: #{path}"
      System.halt(1)
    end
  end
end
