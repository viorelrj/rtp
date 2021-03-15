defmodule RTPTest do
  use ExUnit.Case
  doctest RTP

  test "greets the world" do
    assert RTP.hello() == :world
  end
end
