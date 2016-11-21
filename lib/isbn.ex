defmodule ISBN do
  def valid?(s) when is_binary(s) do
    String.replace(s, "-", "")
    |> String.codepoints
    |> check_valid_isbn
  end
  def valid?(_), do: false

  defp check_valid_isbn(digits) when length(digits) == 10 do
    isbn10_checkdigit(digits) == Enum.at(digits, 9)
  end

  defp check_valid_isbn(digits) when length(digits) == 13 do
    isbn13_checkdigit(digits) == Enum.at(digits, 12)
  end

  defp check_valid_isbn(_), do: false

  defp isbn10_checkdigit(digits) do
    digits
    |> Enum.take(9)
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(10..2)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum
    |> rem(11)
    |> (fn x -> rem(11 - x, 11) end).()
    |> Integer.to_string
    |> String.replace("10", "X")
  end

  defp isbn13_checkdigit(digits) do
    digits
    |> Enum.take(12)
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(Stream.cycle([1, 3]))
    |> IO.inspect
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum
    |> IO.inspect
    |> rem(10)
    |> (fn x -> 10 - x end).()
    |> Integer.to_string
  end
end
