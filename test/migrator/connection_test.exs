defmodule Migrator.ConnectionTest do
  use ExUnit.Case
  alias Migrator.Connection

  test "to_string/1 with a fully described" do
    conn = %Connection{database: "test", hostname: "localhost", password: "testpass", username: "testuser"}
    url  = Connection.to_string(conn)

    assert url == "ecto://testuser:testpass@localhost:5432/test"
  end

  test "to_string/1 without a password" do
    conn = %Connection{database: "test", hostname: "localhost", username: "testuser"}
    url  = Connection.to_string(conn)

    assert url == "ecto://testuser@localhost:5432/test"
  end

  test "from_string/1" do
    conn = Connection.from_string("ecto://testuser:testpass@localhost:5432/test")

    assert conn.username == "testuser"
    assert conn.password == "testpass"
    assert conn.hostname == "localhost"
    assert conn.port == 5432
    assert conn.database == "test"
  end
end
