defmodule DbPostgresTest do
  use ExUnit.Case
  doctest DbPostgres

  test "greets the world" do
    assert DbPostgres.hello() == :world
  end
end
