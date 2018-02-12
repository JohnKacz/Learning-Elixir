defmodule RPNCalc do
  use GenServer
  @moduledoc """
  Documentation for RPNCalc.
  """

  # Client API

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  @doc """
  Peek at the stack

  ## Examples

      iex> {:ok, calc} = RPNCalc.start_link
      iex> RPNCalc.peek(calc)
      []

  """
  def peek(pid) do
    GenServer.call(pid, :peek)
  end

  @doc """
  Push an integer or operation (:+, :-, :x, :/) onto the stack.

  ## Examples

      iex> {:ok, calc} = RPNCalc.start_link()
      iex> RPNCalc.push(calc, 5)
      iex> RPNCalc.peek(calc)
      [5]
      iex> RPNCalc.push(calc, 1)
      iex> RPNCalc.peek(calc)
      [1, 5]
  """
  def push(pid, val) do
    GenServer.cast(pid, {:push, val})
  end

  # Server (callbacks)

  def init(_) do
    {:ok, []}
  end

  def handle_call(:peek, _from, stack) do
    {:reply, stack, stack}
  end

  def handle_cast({:push, val}, [a, b | remainder] = stack) do
    case val do
      :+ -> {:noreply, [b + a | remainder]}

      :- -> {:noreply, [b - a | remainder]}

      :x -> {:noreply, [b * a | remainder]}

      :/ -> {:noreply, [b / a | remainder]}

      _ -> {:noreply, [val | stack]}
    end
  end
  def handle_cast({:push, val}, stack) when is_integer(val), do: {:noreply, [val | stack]}
end
