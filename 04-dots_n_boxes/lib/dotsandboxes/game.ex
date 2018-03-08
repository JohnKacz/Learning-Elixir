defmodule DnB.Game do
  alias DnB.Game.Board
  defstruct board: %Board{}

  def new_game(size) do
    %DnB.Game{board: Board.new_board(size)}
  end
end
