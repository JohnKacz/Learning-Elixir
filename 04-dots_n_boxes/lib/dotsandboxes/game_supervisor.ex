defmodule DnB.GameSupervisor do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_game(size) do
    DynamicSupervisor.start_child(__MODULE__, {DnB.Server, size})
  end
end
