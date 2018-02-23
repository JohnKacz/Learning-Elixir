defmodule DnBTest do
  use ExUnit.Case
  doctest DnB

  test "greets the world" do
    assert DnB.hello() == :world
  end
end
