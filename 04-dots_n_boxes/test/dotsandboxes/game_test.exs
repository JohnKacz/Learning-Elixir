defmodule DnB.GameTest do
  use ExUnit.Case
  doctest DnB.Game

  setup_all do
    {
      :ok,
      game: DnB.Game.new_game(3),
      valid_moves: [{0, 0, :x}, {0, 0, :y}],
      invalid_moves: [{-1, 0, :x}, {0, 5, :x}, {1, 1, :z}],
      single_box: {MapSet.new([{0, 0}]), [{0, 0, :y}, {0, 1, :x}, {1, 0, :y}, {0, 0, :x}]},
      double_box: {
        MapSet.new([{0, 0}, {0, 1}]),
        [
          {0, 0, :x},
          {0, 0, :y},
          {1, 0, :y},
          {1, 1, :y},
          {0, 1, :y},
          {0, 2, :x},
          {0, 1, :x}
        ]
      }
    }
  end

  test "playing a move should move the line from open_lines to the current player's lines", %{
    game: game,
    valid_moves: valid_moves
  } do
    {_,
     %{
       board: %{
         open_lines: open_lines,
         player1_lines: player1_lines,
         player2_lines: player2_lines
       }
     }} = Enum.map_reduce(valid_moves, game, fn move, game -> DnB.Game.play(game, move) end)

    assert MapSet.disjoint?(open_lines, MapSet.new(valid_moves))
    assert MapSet.member?(player1_lines, Enum.at(valid_moves, 0))
    assert MapSet.member?(player2_lines, Enum.at(valid_moves, 1))
  end

  test "playing a move should change the current player to the next player", %{
    game: game = %{current_player: current_player},
    valid_moves: valid_moves
  } do
    assert current_player == :p1
    {:ok, game = %{current_player: current_player}} = DnB.Game.play(game, Enum.at(valid_moves, 0))
    assert current_player == :p2
    {:ok, %{current_player: current_player}} = DnB.Game.play(game, Enum.at(valid_moves, 1))
    assert current_player == :p1
  end

  test "playing an invalid move should return an error and leave the game unchanged.", %{
    game: game,
    invalid_moves: invalid_moves
  } do
    {:error, _reason, new_game} = DnB.Game.play(game, Enum.at(invalid_moves, 0))
    assert new_game == game
    {:error, _reason, new_game} = DnB.Game.play(game, Enum.at(invalid_moves, 1))
    assert new_game == game
    {:error, _reason, new_game} = DnB.Game.play(game, Enum.at(invalid_moves, 2))
    assert new_game == game
  end

  test "playing a move that has already been played should return an error and leave the game unchanged.",
       %{
         game: game,
         valid_moves: [valid_move | _]
       } do
    {:ok, game} = DnB.Game.play(game, valid_move)
    {:error, _reason, unchanged_game} = DnB.Game.play(game, valid_move)

    assert unchanged_game == game
  end

  test "playing a move that completes a box should move the completed box from open_boxes to the current player's boxes.",
       %{
         game: game,
         single_box: {box, moves}
       } do
    {_, game} = Enum.map_reduce(moves, game, fn move, game -> DnB.Game.play(game, move) end)

    assert MapSet.disjoint?(game.board.open_boxes, box)
    assert MapSet.equal?(game.board.player2_boxes, box)
  end

  test "playing a move that completes two boxes should move the both boxes from open_boxes to the current player's boxes.",
       %{
         game: game,
         double_box: {boxes, moves}
       } do
    {_, game} = Enum.map_reduce(moves, game, fn move, game -> DnB.Game.play(game, move) end)

    assert MapSet.disjoint?(game.board.open_boxes, boxes)
    assert MapSet.equal?(game.board.player1_boxes, boxes)
  end

  test "playing a move that completes a box should keep the current player the same.", %{
    game: game,
    single_box: {box, moves}
  } do
    {_, %{current_player: current_player}} =
      Enum.map_reduce(moves, game, fn move, game -> DnB.Game.play(game, move) end)

    assert current_player == :p2
  end
end
