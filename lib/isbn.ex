defmodule ISBN do
  alias ISBN.{ISBN10, ISBN13}

  @doc """
  Validates an ISBN-10 or ISBN-13 code.

  Examples:
      iex> ISBN.valid?("978-1-93778-558-1")
      true

      iex> ISBN.valid?("0-8044-2957-X")
      true

      iex> ISBN.valid?("0-8044-2957-0")
      false

      iex> ISBN.valid?("978-92-95055-02-5")
      true
  """
  def valid?(str) when is_binary(str), do: str |> chars |> valid?
  def valid?(chars) when length(chars) == 10, do: ISBN10.valid?(chars)
  def valid?(chars) when length(chars) == 13, do: ISBN13.valid?(chars)
  def valid?(_), do: false

  @doc """
  Example:
      iex> ISBN.normalize("978-3-16-148410 0")
      "9783161484100"

      iex> ISBN.normalize(nil)
      nil

      iex> ISBN.normalize(1234)
      nil
  """
  def normalize(isbn) when is_binary(isbn), do: isbn |> String.replace(~r/[-\s]/, "")
  def normalize(_), do: nil

  @doc """
  Forces and ISBN to ISBN-13 format. Does not validate.

  Example:
      iex> ISBN.to_isbn13("0-306-40615-2")
      "9780306406157"

      iex> ISBN.to_isbn13("9780306406154")
      "9780306406154"

      iex> ISBN.to_isbn13("0-8044-2957-X")
      "9780804429573"

      iex> ISBN.to_isbn13("asd")
      {:error, :invalid_isbn}
  """
  def to_isbn13(isbn) when is_binary(isbn) do
    isbn = isbn |> normalize
    case String.length(isbn) do
      10 -> ISBN10.to_isbn13(isbn)
      13 -> isbn
      _ -> {:error, :invalid_isbn}
    end
  end
  def to_isbn13(_), do: {:error, :invalid_isbn}

  @doc """
  Example:
      iex> ISBN.chars("978-3-16-148410 0")
      ["9", "7", "8", "3", "1", "6", "1", "4", "8", "4", "1", "0", "0"]
  """
  def chars(isbn) do
    isbn
    |> normalize
    |> String.codepoints
  end
end
