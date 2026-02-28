defmodule Elis do
  @moduledoc """
  Documentation for `Elis`.

  Microlisp eval
  """

  def eval(s) do
    a = ast(s)
    env = %{}
    {r, _e} = Enum.map_reduce(a, env, fn x, e -> eval_form(x, e) end)
    r
  end

  def ast(s) do
    s |> Tok.tokenize() |> P.parse()
  end

  defp eval_form(args, env) when is_list(args) do
    {[op | evaled_args], up_env} =
      Enum.map_reduce(
        args,
        env,
        fn x, e -> eval_form(x, e) end
      )

    do_eval_form(op, evaled_args, up_env)
  end

  defp eval_form(val, env) do
    case Integer.parse(val) do
      {num, ""} -> {num, env}
      _ -> {Map.get(env, val, val), env}
    end
  end

  # XXX:maybe this should be just in env, not hardcoded?
  defp do_eval_form("+", args, env) do
    {Enum.reduce(args, 0, &+/2), env}
  end

  defp do_eval_form("-", args, env) do
    {Enum.reduce(args, &-/2), env}
  end

  defp do_eval_form("*", args, env) do
    {Enum.reduce(args, 1, &*/2), env}
  end

  defp do_eval_form("/", args, env) do
    {Enum.reduce(Enum.reverse(args), 1, &div/2), env}
  end

  defp do_eval_form("def", args, env) do
    case args do
      [name, val] -> {val, Map.put(env, name, val)}
      _ -> raise "Invalid number of arguments for `def`: #{inspect(args)}"
    end
  end

  defp do_eval_form(op, args, env) do
    case Map.get(env, op) do
      nil ->
        raise "Unknown operation #{op}; env: #{inspect(env)}!"

      f ->
        raise "Function calls are not supported #{f}; args: #{inspect(args)}; env: #{inspect(env)}!"
    end
  end
end
