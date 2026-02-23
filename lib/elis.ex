defmodule Elis do
  @moduledoc """
  Documentation for `Elis`.

  Microlisp eval
  """

  def eval(s) do
    ast = s |> Tok.tokenize() |> P.parse()
    Enum.map(ast, fn x -> eval_form(x) end)
  end

  defp eval_form(args) when is_list(args) do
    [op | evaled_args] = Enum.map(args, fn x -> eval_form(x) end)

    do_eval_form(op, evaled_args)
  end

  defp eval_form(val) do
    case Integer.parse(val) do
      {num, ""} -> num
      _ -> val
    end
  end

  defp do_eval_form("+", args) do
    Enum.reduce(args, 0, &+/2)
  end

  defp do_eval_form("-", args) do
    Enum.reduce(args, &-/2)
  end

  defp do_eval_form("*", args) do
    Enum.reduce(args, 1, &*/2)
  end

  defp do_eval_form("/", args) do
    Enum.reduce(Enum.reverse(args), 1, &div/2)
  end

  defp do_eval_form(unknown, __args) do
    raise "Unknown operation #{unknown}!"
  end
end
