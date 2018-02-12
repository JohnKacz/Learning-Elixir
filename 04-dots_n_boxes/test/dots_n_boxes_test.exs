defmodule DnBTest do
  use ExUnit.Case
  # doctest DnB

  test "create a new game" do
    game = DnB.new_game()
    assert is_pid(game)
  end
end
