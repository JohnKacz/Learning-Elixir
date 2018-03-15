defmodule DnB.Server do
  use GenServer

  def start_link(size) do
    GenServer.start_link(__MODULE__, size)
  end

  # Server API

  def init(size) do
    {:ok, DnB.Game.new_game(size)}
  end

  def handle_call({:print}, _from, game) do
    {:reply, DnB.Game.Board.print(game.board), game}
  end

  def handle_call({:play, line}, _from, game) do
    case DnB.Game.play(game, line) do
      {:ok, game} ->
        {:reply, DnB.Game.Board.print(game.board), game}

      {:error, reason, game} ->
        {:reply, IO.puts(reason), game}
    end
  end

  def handle_call({:auto, number_of_moves}, _from, game) do
    case DnB.Game.auto_play(game, number_of_moves) do
      {:ok, game} ->
        {:reply, DnB.Game.Board.print(game.board), game}

      {:error, reason, game} ->
        {:reply, IO.puts(reason), game}
    end
  end
end
