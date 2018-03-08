defmodule DnB.Server do
  use GenServer

  def start_link(size) do
    GenServer.start_link(__MODULE__, size)
  end

  # Server API

  def init(size) do
    {:ok, DnB.Game.new_game(size)}
  end

  def handle_call({:print}, _from, game = %{board: board}) do
    {:reply, DnB.Game.Board.print(board), game}
  end
end
