defmodule ElixirTodoListWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint ElixirTodoListWeb.Endpoint

      use ElixirTodoListWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import ElixirTodoListWeb.ConnCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(ElixirTodoList.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
