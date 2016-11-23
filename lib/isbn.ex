defmodule ISBN do
  @moduledoc """
  Provides functions to work with ISBNs.
  """

  @doc """
  Checks if the given string is a valid ISBN.

  Works with both ISBN-10 and ISBN-13. Allows hyphens in the string.

      iex> ISBN.valid?("0-306-40615-2")
      true

      iex> ISBN.valid?("1234567")
      false

  """
  def valid?(s) when is_binary(s) do
    remove_dashes(s)
    |> String.codepoints
    |> check_valid_isbn
  end
  def valid?(_), do: false

  @doc """
  Converts ISBN 10 to ISBN 13.

      iex> ISBN.convert_10_to_13("161729201X")
      "9781617292019"

  """
  def convert_10_to_13(str) do
    str
    |> remove_dashes
    |> _convert_isbn10_to_13
  end

  @doc """
  Checks if the string is a valid ISBN 10 number.
  """
  def valid_isbn10?(str) do
    str
    |> remove_dashes
    |> (fn s -> (String.length(s) == 10) && valid?(s) end).()
  end

  defp _convert_isbn10_to_13(str) do
    if valid_isbn10?(str) do
      "978#{String.slice(str, 0..8)}"
      |> append_isbn13_check_digit
    else
      {:error, :invalid_isbn}
    end
  end

  defp append_isbn13_check_digit(s) do
    s <> isbn13_checkdigit(String.codepoints(s))
  end

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
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum
    |> rem(10)
    |> (fn x -> 10 - x end).()
    |> Integer.to_string
  end

  def remove_dashes(s), do: String.replace(s, "-", "")
end
