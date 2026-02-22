defmodule Elis do
  @moduledoc """
  Documentation for `Elis`.

  Microlisp eval
  """

  def eval(s) do
    s |> Tok.tokenize() |> P.parse()
  end
end
