defmodule Hydrex do
  @moduledoc ~S"""
  Hydrex provides automatic hydration of virtual fields in your Ecto models.
  By deriving the `Hydrex.Hydratable` protocol and defining resolver functions for your virtual fields,
  you can easily populate these fields when querying your models.

  To use Hydrex, define virtual fields in your Ecto schema and implement resolver functions with matching names.
  Then, derive your schema with `Hydrex.Hydratable`.

  Use `Hydrex.Hydratable.Utils.maybe_hydrate/2` to control hydration when fetching records.

  ## Examples

  Here's how you can use Hydrex to hydrate virtual fields in your Ecto schemas:

      defmodule MyApp.Url do
        use Ecto.Schema

        @derive {Hydrex.Hydratable, []}
        schema "urls" do
          field :link, :string
          field :title, :string
          field :is_safe, :boolean, virtual: true
        end

        def is_safe(url) do
          String.starts_with?(url.link, "https://")
        end
      end

  When querying your models, you can choose to hydrate the virtual fields:

      import Hydrex.Hydratable.Utils, only: [maybe_hydrate: 2]
      Repo.all(MyApp.Url) |> maybe_hydrate(hydrate: true)
      # or
      Repo.all(MyApp.Url) |> maybe_hydrate(true)


  See the documentation for installation and usage details.
  """
end
