defmodule DnB.Game do
  alias __MODULE__
  alias DnB.Game.Board

  defstruct board: %Board{}

  def new_game(size) do
    %Game{board: Board.new_board(size)}
  end

  def play(game, line) do
    game = %Game{
      board: %Board{
        game.board
        | open_lines: MapSet.delete(game.board.open_lines, line),
          player1_lines: MapSet.put(game.board.player1_lines, line)
      }
    }

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

    {:ok, game}
  end
end
