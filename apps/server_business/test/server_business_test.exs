defmodule ServerBusinessTest do
  use ExUnit.Case
  doctest ServerBusiness

  test "greets the world" do
    assert ServerBusiness.hello() == :world
  end
end
