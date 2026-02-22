defmodule ElisTest do
  use ExUnit.Case
  doctest Elis

  test "eval" do
    assert Elis.eval("(+ 42 0)") == 42
    assert Elis.eval("(* 7 6)") == 42
  end
end
