# Hydrex

Hydrex allows you to automattically fill up all virtual fields or your Ecto model at once.

In order to use it you need to define a virtual field in your Ecto model and a resolver function for that virtual field with the same name and finally you `derive` your model with `Hydratable` protocol.

```elixir
defmodule MyApp.Url do
  #...
  @derive {Hydrex.Hydratable, []}
  schema "urls" do
    field :link, :string
    field :title, :string

    # Virtual field
    field :is_safe, :boolean, virtual: true
  end

  # resolver function
  def is_safe(url) do
    String.starts_with?(url.link, "https://")
  end
end
```

And when calling you can pass an opts list informing whether or not you want your ecto models hydrated.

```elixir
import HelloWeb.Hydratable.Utils, only: [maybe_hydrate: 2]

Repo.all(Url) |> maybe_hydrate(hydrate: true)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hydrex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hydrex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/hydrex>.

