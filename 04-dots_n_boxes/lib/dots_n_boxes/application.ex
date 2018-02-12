defmodule DnB.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: DnB.Supervisor]
    DynamicSupervisor.start_link(opts)
  end
end
