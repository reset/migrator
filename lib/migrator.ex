defmodule Migrator do
  alias Migrator.Connection, as: Conn

  use Application

  def configure(options) do
    Enum.each options, fn(option) ->
      config_set(option)
    end
  end

  def configuration do
    Application.get_all_env(:migrator)
  end

  @doc """
  Create a database from a connection struct.
  """
  @spec create(Conn.t) :: :ok | {:error, term}
  def create(%Conn{} = conn) do
    configure(connection: conn, url: Conn.to_string(conn))
    {:ok, pid} = Migrator.Repo.start_link
    Ecto.Storage.up(Migrator.Repo)
    true = Process.exit(pid, :normal)
    :ok
  end

  @doc """
  Drop a database from a connection struct.
  """
  @spec drop(Conn.t) :: :ok | {:error, term}
  def drop(%Conn{} = conn) do
    configure(connection: conn, url: Conn.to_string(conn))
    {:ok, pid} = Migrator.Repo.start_link
    Ecto.Storage.down(Migrator.Repo)
    true = Process.exit(pid, :normal)
    :ok
  end

  @doc """
  Run the given migrations against the given database.
  """
  @spec up(binary, Conn.to, list) :: [integer]
  def up(migrations, %Conn{} = conn, opts \\ []) do
    configure(migrations_path: migrations, connection: conn, url: Conn.to_string(conn))

    unless opts[:to] || opts[:step] || opts[:all] do
      opts = Keyword.put(opts, :all, true)
    end

    {:ok, pid} = Migrator.Repo.start_link
    Ecto.Migrator.run(Migrator.Repo, configuration[:migrations_path], :up, opts)
    true = Process.exit(pid, :normal)
    :ok
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
    config_set(key, conn)
  end
  defp config_set({:url, string}) do
    config_set(Migrator.Repo, url: string)
  end
  defp config_set({:migrations_path = key, path}) do
    path = Path.expand(path)
    validate_path(path)
    config_set(key, path)
  end

  defp config_set(key, value), do: Application.put_env(:migrator, key, value)

  defp validate_path(path) do
    unless File.exists?(path) do
      IO.puts "Path to migrations does not exist: #{path}"
      System.halt(1)
    end
  end
end
