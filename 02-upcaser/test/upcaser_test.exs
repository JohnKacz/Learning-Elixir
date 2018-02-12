defmodule UpcaserTest do
  use ExUnit.Case
  doctest Upcaser

  test "greets the world" do
    assert Upcaser.hello() == :world
  end

  test "starting the service" do
    assert {:ok, pid} = Upcaser.start
    assert is_pid(pid)
  end

  test "sending a string to be upcased" do
    {:ok, upcaser_pid} = Upcaser.start()
    assert {:ok, "TESTING"} = Upcaser.upcase(upcaser_pid, "testing")
  end
end
