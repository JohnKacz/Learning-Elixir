defmodule DnB.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    DynamicSupervisor.start_link(name: DnB.GameSupervisor, strategy: :one_for_one)
  end
end
