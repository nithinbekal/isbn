defmodule ISBN.ISBN10 do
  @moduledoc """
  Validation and tools for ISBN-10
  """

  import ISBN, only: [normalize: 1, chars: 1]

  @doc """
  Validates ISBN-10

  Examples:
      iex> ISBN.ISBN10.valid?("0-8219-1069-8")
      true
  """
  def valid?(code) when is_binary(code), do: code |> normalize |> chars |> valid?
  def valid?(chars) when is_list(chars) and length(chars) == 10 do
    checkdigit(chars) == Enum.at(chars, 9)
  end
  def valid?(_), do: false

  @doc """
  ISBN-10 codes can be converted to ISBN-13 by prepending "978" and re-calculating the checkdigit.

  Example:
      iex> ISBN.ISBN10.to_isbn13("1937785580")
      "9781937785581"
  """
  def to_isbn13(str) do
    isbn = normalize(str)
    case valid?(isbn) do
      false -> {:error, :invalid}
      _ -> append_isbn_13_checkdigit("978" <> String.slice(isbn, 0..8))
    end
  end

  @doc """
  Calculate checksum. Return type is string since when the digit is "10", "X" is used in its place

  Examples:
      iex> ISBN.ISBN10.checkdigit(["0", "8", "0", "4", "4", "2", "9", "5", "7"])
      "X"
  """
  def checkdigit(chars) do
    chars
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

  defp append_isbn_13_checkdigit(stub) do
    new_checkdigit = stub |> chars |> ISBN.ISBN13.checkdigit
    stub <> new_checkdigit
  end
end
