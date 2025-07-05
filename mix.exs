defmodule Hydrex.MixProject do
  use Mix.Project

  def project do
    [
      app: :hydrex,
      version: "0.1.1",
      elixir: "~> 1.18",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto, "~> 3.10", only: :test, runtime: false}
    ]
  end
end
