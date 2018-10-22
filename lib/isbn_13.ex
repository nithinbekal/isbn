defmodule ISBN.ISBN13 do
  @moduledoc """
  Validation for ISBN-13
  """

  import ISBN, only: [normalize: 1, chars: 1]

  @doc """
  Validate the chechksum on an ISBN-10 or ISBN-13 string

  Examples:
      iex> ISBN.ISBN13.valid?("978-1-93778-558-1")
      true

      iex> ISBN.ISBN13.valid?("978-1-93778-558-0")
      false
  """
  def valid?(code) when is_binary(code), do: code |> normalize |> chars |> valid?
  def valid?(chars) when is_list(chars) and length(chars) == 13 do
    checkdigit(chars) == Enum.at(chars, 12)
  end
  def valid?(_), do: :what

  def checkdigit(chars) do
    chars
    |> Enum.take(12)
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(Stream.cycle([1, 3]))
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum
    |> rem(10)
    |> (fn x -> 10 - x end).()
    |> Integer.to_string
  end
end
