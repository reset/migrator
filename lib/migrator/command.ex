defmodule Migrator.Command do
  use Behaviour

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
      import Migrator, only: [configuration: 0]
    end
  end

  defcallback run(list) :: no_return
end
