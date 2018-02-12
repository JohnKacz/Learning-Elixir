defmodule DnB.Server do
  use GenServer

  # Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  # Server API
  def init(_) do
    {:ok, []}
  end
end
