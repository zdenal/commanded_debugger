defmodule CommandedDebuggerTest do
  use ExUnit.Case
  doctest CommandedDebugger

  test "greets the world" do
    assert CommandedDebugger.hello() == :world
  end
end
