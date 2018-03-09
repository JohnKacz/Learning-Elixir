defmodule DnB.GameTest do
  use ExUnit.Case
  doctest DnB.Game

  setup_all do
    game = DnB.Game.new_game(3)

    {:ok, game: game}
  end

  test "playing a move should move the line from open_lines to the current player's lines", %{
    game: game
  } do
    line = {0, 0, :x}

    {:ok, %{board: %{open_lines: open_lines, player1_lines: player1_lines}}} =
      DnB.Game.play(game, line)

    refute MapSet.member?(open_lines, line)
    assert MapSet.member?(player1_lines, line)
  end

  @tag :pending
  test "playing a move should make change the current player to the next player"

  @tag :pending
  test "playing an invalid move should return an error and leave the game unchanged."

  @tag :pending
  test "playing a move that has already been played should return an error and leave the game unchanged."

  @tag :pending
  test "playing a move that completes a box should move the completed box from open_boxes to the current player's boxes."

  @tag :pending
  test "playing a move that completes a box should keep the current player the same."
end
