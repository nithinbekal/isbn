defmodule ISBN.Mixfile do
  use Mix.Project

  def project do
    [app: :isbn,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: [],
     package: package,
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp package do
    [
      name: :isbn,
      files: ["lib", "mix.exs"],
      maintainers: ["Nithin Bekal"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/nithinbekal/isbn"},
    ]
  end
end
