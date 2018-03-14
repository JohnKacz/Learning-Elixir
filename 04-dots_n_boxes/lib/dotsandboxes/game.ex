defmodule DnB.Game do
  alias __MODULE__
  alias DnB.Game.Board

  defstruct board: %Board{},
            current_player: :p1

  def new_game(size) do
    %Game{board: Board.new_board(size)}
  end

  def play(game, line) do
    # Find any boxes that should be completed
    boxes = new_completed_boxes(game.board, line)
    # Validate the line
    case {MapSet.member?(game.board.open_lines, line), game.current_player} do
      # Play the line for Player 1
      {true, :p1} ->
        game = %Game{
          board: %Board{
            game.board
            | open_lines: MapSet.delete(game.board.open_lines, line),
              player1_lines: MapSet.put(game.board.player1_lines, line),
              open_boxes: MapSet.difference(game.board.open_boxes, boxes),
              player1_boxes: MapSet.union(game.board.player1_boxes, boxes)
          },
          current_player: next_player(game.current_player, MapSet.size(boxes))
        }

        {:ok, game}

      # Play the line for Player 2
      {true, :p2} ->
        game = %Game{
          board: %Board{
            game.board
            | open_lines: MapSet.delete(game.board.open_lines, line),
              player2_lines: MapSet.put(game.board.player2_lines, line),
              open_boxes: MapSet.difference(game.board.open_boxes, boxes),
              player2_boxes: MapSet.union(game.board.player2_boxes, boxes)
          },
          current_player: next_player(game.current_player, MapSet.size(boxes))
        }

        {:ok, game}

      # Return an error
      {true, _} ->
        {:error, "Invalid Player", game}

      # Return an error
      {false, _} ->
        {:error, "Invalid Move", game}
    end
  end

  defp new_completed_boxes(board, line = {x, y, o}) do
    box1 = {x, y}
    box2 = if o == :x, do: {x, y - 1}, else: {x - 1, y}

    case {completes_box?(board, line, box1), completes_box?(board, line, box2)} do
      {true, true} -> MapSet.new([box1, box2])
      {true, false} -> MapSet.new([box1])
      {false, true} -> MapSet.new([box2])
      {false, false} -> MapSet.new()
    end
  end

  defp completes_box?(%{open_lines: ol, open_boxes: ob}, line, box) do
    # A box is not yet completed AND none of the lines for a box are open
    MapSet.member?(ob, box) && ol |> MapSet.delete(line) |> MapSet.disjoint?(lines_for(box))
  end

  defp lines_for({x, y}), do: MapSet.new([{x, y, :x}, {x, y, :y}, {x + 1, y, :y}, {x, y + 1, :x}])

  defp next_player(player, new_box_count) when new_box_count > 0, do: player

  defp next_player(player, _) do
    if player == :p1, do: :p2, else: :p1
  end
end
