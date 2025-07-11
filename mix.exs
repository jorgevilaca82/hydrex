defmodule Hydrex.MixProject do
  use Mix.Project

  def project do
    [
      app: :hydrex,
      version: "0.1.2",
      elixir: "~> 1.18",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      name: "hydrex",
      description: "Hydrex is a library for hydrating Ecto structs with virtual fields.",
      maintainers: ["Jorge Vilaca"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/jorgevilaca82/hydrex"
      }
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto, "~> 3.10", only: [:dev, :test], runtime: false}
    ]
  end
end
