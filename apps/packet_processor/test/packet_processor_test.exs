defmodule PacketProcessorTest do
  use ExUnit.Case
  doctest PacketProcessor

  test "greets the world" do
    assert PacketProcessor.hello() == :world
  end
end
