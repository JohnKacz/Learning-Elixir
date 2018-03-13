defmodule DnB.Game do
  alias __MODULE__
  alias DnB.Game.Board

  defstruct board: %Board{},
            current_player: :p1

  def new_game(size) do
    %Game{board: Board.new_board(size)}
  end

  def play(game, line) do
    # Validate the line
    case {MapSet.member?(game.board.open_lines, line), game.current_player} do
      # Play the line
      {true, :p1} ->
        game = %Game{
          board: %Board{
            game.board
            | open_lines: MapSet.delete(game.board.open_lines, line),
              player1_lines: MapSet.put(game.board.player1_lines, line)
          },
          current_player: next_player(game.current_player)
        }

        {:ok, game}

      # Play the line
      {true, :p2} ->
        game = %Game{
          board: %Board{
            game.board
            | open_lines: MapSet.delete(game.board.open_lines, line),
              player2_lines: MapSet.put(game.board.player2_lines, line)
          },
          current_player: next_player(game.current_player)
        }

        {:ok, game}

      {true, _} ->
        {:ok, game}

      # Return an error
      {false, _} ->
        {:error, "Invalid Move", game}
    end

    # Another implementation for learning purposes
    # game =
    #   game
    #   |> put_in(
    #     [Access.key(:board), Access.key(:open_lines)],
    #     MapSet.delete(game.board.open_lines, line)
    #   )
    #   |> put_in(
    #     [Access.key(:board), Access.key(:player1_lines)],
    #     MapSet.put(game.board.player1_lines, line)
    #   )
    #   |> put_in([Access.key(:current_player)], next_player(game.current_player))
  end

  def validate_line({x, y, ord}, size) do
    {x, y, ord}
  end

  defp next_player(current_player) do
    case current_player do
      :p1 -> :p2
      :p2 -> :p1
    end
  end
end
