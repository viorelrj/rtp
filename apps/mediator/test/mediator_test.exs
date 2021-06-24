defmodule MediatorTest do
  use ExUnit.Case
  doctest Mediator

  test "greets the world" do
    assert Mediator.hello() == :world
  end
end
