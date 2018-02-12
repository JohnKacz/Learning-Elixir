defmodule DnB do
  @moduledoc """
  Documentation for DnB.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DnB.hello
      :world

  """
  def new_game do
    {:ok, pid} = DynamicSupervisor.start_child(DnB.Supervisor, DnB.Server)
    pid
  end
end
