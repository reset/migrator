defmodule Migrator.Connection do
  import Ecto.Repo.Supervisor, only: [parse_url: 1]

  @type t :: %__MODULE__{
    username: binary,
    password: binary | nil,
    hostname: binary,
    database: binary | nil,
    port: integer
  }

  defstruct username: "postgres",
    password: nil,
    hostname: "localhost",
    database: nil,
    port:     5432

  @doc """
  Convert a connection struct into a connection uri.
  """
  @spec to_string(t) :: binary
  def to_string(%__MODULE__{} = conn) do
    Map.from_struct(conn) |> build_uri
  end

  @doc """
  Convert a connection uri into a connection struct.
  """
  @spec from_string(binary) :: t
  def from_string(uri) when is_binary(uri) do
    struct(__MODULE__, parse_url(uri))
  end

  @doc """
  Convert a connection struct into a list of connection options.
  """
  @spec to_list(t) :: list
  def to_list(%__MODULE__{} = conn) do
    Map.from_struct(conn) |> Dict.to_list
  end

  #
  # Private
  #

  defp build_uri(%{username: user} = conn) do
    Dict.drop(conn, [:username]) |> build_uri("ecto://#{user}")
  end
  defp build_uri(%{password: nil} = conn, uri) do
    Dict.drop(conn, [:password]) |> build_uri(uri)
  end
  defp build_uri(%{password: pass} = conn, uri) do
    Dict.drop(conn, [:password]) |> build_uri(uri <> ":#{pass}")
  end
  defp build_uri(%{hostname: host} = conn, uri) do
    Dict.drop(conn, [:hostname]) |> build_uri(uri <> "@#{host}")
  end
  defp build_uri(%{port: nil} = conn, uri) do
    Dict.drop(conn, [:port]) |> build_uri(uri)
  end
  defp build_uri(%{port: port} = conn, uri) do
    Dict.drop(conn, [:port]) |> build_uri(uri <> ":#{port}")
  end
  defp build_uri(%{database: database} = conn, uri) do
    Dict.drop(conn, [:database]) |> build_uri(uri <> "/#{database}")
  end
  defp build_uri(_, uri) do
    uri
  end
end

defimpl String.Chars, for: Migrator.Connection do
  def to_string(nil) do
    ""
  end

  def to_string(conn) do
    Migrator.Connection.to_string(conn)
  end
end
