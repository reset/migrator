defmodule Ecto.MultiSchemaMigration do
  @spec run(atom, atom, binary) :: no_return
  def run(module, function, schema) do
    Ecto.Migration.Runner.execute "CREATE SCHEMA IF NOT EXISTS #{schema}"
    Ecto.Migration.Runner.execute "SET search_path TO #{schema}"
    apply(module, function, [schema])
    Ecto.Migration.Runner.execute "SET search_path TO public"
  end

  @doc """
  Return the Shard ID of the given schema.
  """
  @spec shard_id(binary) :: integer
  def shard_id(schema) do
    String.split(schema, "_")
    |> List.last
    |> String.to_integer
  end

  defmacro __using__(opts) do
    quote do
      use Ecto.Migration, unquote(opts)
      @before_compile unquote(__MODULE__)
      import unquote(__MODULE__), only: [shard_id: 1]
    end
  end

  defmacro __before_compile__(env) do
    prefix  = Module.get_attribute(env.module, :schema_prefix) || "shard"
    count   = Module.get_attribute(env.module, :schema_count) || 1
    schemas = schemas(prefix, count)
    cond do
      Module.defines?(env.module, {:change, 1}, :def) ->
        quote do
          def change do
            for schema <- unquote(schemas) do
              unquote(__MODULE__).run(__MODULE__, :change, schema)
            end
          end
        end
      Module.defines?(env.module, {:up, 1}, :def) ->
        quote do
          def up do
            for schema <- unquote(schemas) do
              unquote(__MODULE__).run(__MODULE__, :up, schema)
            end
          end

          def down do
            for schema <- unquote(schemas) do
              unquote(__MODULE__).run(__MODULE__, :down, schema)
            end
          end
        end
      true ->
        raise "module #{inspect env.module} did not export `change/1` nor `up/1`"
    end
  end

  defp schemas(prefix, count) do
    Range.new(1, count)
    |> Enum.into([])
    |> Enum.map(&("#{prefix}_#{(&1 - 1)}"))
  end
end
