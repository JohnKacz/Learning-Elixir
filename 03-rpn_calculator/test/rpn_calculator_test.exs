defmodule RPNCalcTest do
  use ExUnit.Case
  doctest RPNCalc

  test "adding" do
    {:ok, calc} = RPNCalc.start_link()
    RPNCalc.push(calc, 5)
    RPNCalc.push(calc, 1)
    RPNCalc.push(calc, :+)
    assert RPNCalc.peek(calc) == [6]
  end

  test "subtracting" do
    {:ok, calc} = RPNCalc.start_link()
    RPNCalc.push(calc, 5)
    RPNCalc.push(calc, 1)
    RPNCalc.push(calc, :-)
    assert RPNCalc.peek(calc) == [4]
  end

  test "multiplying" do
    {:ok, calc} = RPNCalc.start_link()
    RPNCalc.push(calc, 5)
    RPNCalc.push(calc, 2)
    RPNCalc.push(calc, :x)
    assert RPNCalc.peek(calc) == [10]
  end

  test "wikipedia example" do
    {:ok, calc} = RPNCalc.start_link()
    RPNCalc.push(calc, 5)
    RPNCalc.push(calc, 1)
    RPNCalc.push(calc, 2)
    RPNCalc.push(calc, :+)
    RPNCalc.push(calc, 4)
    RPNCalc.push(calc, :x)
    RPNCalc.push(calc, :+)
    RPNCalc.push(calc, 3)
    RPNCalc.push(calc, :-)
    assert RPNCalc.peek(calc) == [14]
  end
end
