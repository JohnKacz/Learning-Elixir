defmodule DnB do
  @moduledoc """
  A game played by drawing lines on a grid and trying to make boxes.
  """

  @doc """
  Start a new game of Dots and Boxes

  ## Examples

      iex> {:ok, game_pid} = DnB.new_game()
      iex> is_pid(game_pid)
      true
  """
  def new_game(size \\ 3) do
    DnB.GameSupervisor.add_game(size)
  end

  @doc """
  Prints out the game board
  """
  def print_game(game_pid) do
    GenServer.call(game_pid, {:print})
  end

  @doc """
  Make a play
  """
  def play_move(game_pid, line) do
    GenServer.call(game_pid, {:play, line})
  end

  @doc """
  Automatically play a given number of moves.
  """
  def auto_play(game_pid, number_of_moves) do
    GenServer.call(game_pid, {:auto, number_of_moves})
  end

  @doc """
  Start a new game of Dots and Boxes
  """
  def quit_game(game_pid) do
    DynamicSupervisor.terminate_child(DnB.GameSupervisor, game_pid)
  end

  @doc """
  Utility to check which games are under supervision
  """
  def active_games() do
    DynamicSupervisor.which_children(DnB.GameSupervisor)
  end

  @doc """
  Utility to check how many games are under supervision
  """
  def active_games_count() do
    DynamicSupervisor.count_children(DnB.GameSupervisor)
  end
end
