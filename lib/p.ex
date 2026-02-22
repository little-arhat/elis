defmodule P do
  @moduledoc """
  Documentation for `Elis`.

  Microlisp parser
  """

  def parse(tokens) do
    parse(tokens, []) |> Enum.reverse()
  end

  defp parse(tokens, ast) do
    {new, rest} = do_parse(tokens, [])

    case rest do
      [] -> [new | ast]
      more -> parse(more, [new | ast])
    end
  end

  defp do_parse([], [current]) do
    {Enum.reverse(current), []}
  end

  defp do_parse(["(" | rest], []) do
    do_parse(rest, [[]])
  end

  defp do_parse(["(" | rest], [current | parent]) do
    do_parse(rest, [[] | [current | parent]])
  end

  defp do_parse([")" | rest], [current | parent]) do
    completed = Enum.reverse(current)

    case parent do
      [next_current | next_parent] ->
        do_parse(rest, [[completed | next_current] | next_parent])

      [] ->
        {completed, rest}
    end
  end

  defp do_parse([expr | rest], [current | parent]) do
    do_parse(rest, [[expr | current] | parent])
  end
end
