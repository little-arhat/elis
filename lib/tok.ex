defmodule Tok do
  def tokenize(s) do
    s |> String.trim() |> tokenize([])
  end

  defp tokenize("", tokens) do
    Enum.reverse(tokens)
  end

  defp tokenize(<<"(", rest::binary>>, tokens) do
    tokenize(rest, ["(" | tokens])
  end

  defp tokenize(<<")", rest::binary>>, tokens) do
    tokenize(rest, [")" | tokens])
  end

  defp tokenize(<<" ", rest::binary>>, tokens) do
    tokenize(rest, tokens)
  end

  defp tokenize(subexpr, tokens) do
    {token, rest} = read_token(subexpr)
    tokenize(rest, [token | tokens])
  end

  defp read_token(expression) do
    case Regex.run(~r/^[^\s\(\)]+/, expression, return: :binary) do
      [token] ->
        len = String.length(token)
        {token, String.slice(expression, len..-1//1)}

      nil ->
        {"", ""}
    end
  end
end
