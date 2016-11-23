defmodule ISBNTest do
  use ExUnit.Case
  doctest ISBN

  test "valid?/1 returns false if input is not string" do
    refute ISBN.valid?(123)
  end

  test "valid?/1 returns false if length is not 10 or 13" do
    refute ISBN.valid?("345678")
    refute ISBN.valid?("12-3456-78")
    refute ISBN.valid?("12-3456-789-01")
  end

  test "valid?/1 returns true for valid ISBN 10" do
    assert ISBN.valid?("076243631X") == true
    assert ISBN.valid?("0-306-40615-2") == true
    assert ISBN.valid?("0-590-76484-5") == true
  end

  test "valid?/1 rejects invalid 10 digit codes" do
    refute ISBN.valid?("99999-999-9-X")
    refute ISBN.valid?("0-590-76484-0")
  end

  test "valid?/1 accepts valid ISBN 13 codes" do
    assert ISBN.valid?("978-0-306-40615-7")
  end

  test "valid_isbn10?/1 checks validity" do
    assert ISBN.valid_isbn10?("076243631X") == true
    refute ISBN.valid_isbn10?("978-0-306-40615-7")
  end

  test "convert_10_to_13/1 converts valid isbns" do
    assert "9781617292019" == ISBN.convert_10_to_13("161729201X")
    assert "9781937785581" == ISBN.convert_10_to_13("1937785580")
  end

  test "convert_10_to_13/1 fails for invalid isbn" do
    assert {:error, :invalid_isbn} == ISBN.convert_10_to_13("123")
  end
end
