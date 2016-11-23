# ISBN


## Installation

Add `isbn` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:isbn, "~> 0.1.0"}]
end
```

## Examples

`ISBN.valid?/1` checks if the given string is a valid ISBN.

```elixir
ISBN.valid?("0-306-40615-2")
#=> true

ISBN.valid?("1234567")
#=> false
```

