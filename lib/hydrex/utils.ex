defmodule Hydrex.Hydratable.Utils do
  @moduledoc """
  Utility functions for hydrating Ecto structs with virtual fields.
  """
  alias Hydrex.Hydratable

  @doc """
  Conditionally hydrates the given data.

  # Parameters
  - `data`: The Ecto struct or a list of structs to hydrate.
  - `opts`: Options to control hydration. If `true`, all virtual fields will be hydrated.
    If `false`, no virtual fields will be hydrated.
    If a keyword list is provided, hydration will occur if `:hydrate` is `true`
    or a list of virtual fields must be provided.

  # Examples

      iex> import Hydrex.Hydratable.Utils, only: [maybe_hydrate: 2]
      iex> my_url = %MyApp.Url{link: "https://example.com"}
      iex> maybe_hydrate(my_url, true)
      iex> maybe_hydrate(my_url, [hydrate: true])
      iex> maybe_hydrate(my_url, [hydrate: [:is_safe]])

  """
  @spec maybe_hydrate(any(), boolean() | keyword()) :: any()
  def maybe_hydrate(data, true), do: Hydratable.hydrate(data)
  def maybe_hydrate(data, false), do: data

  def maybe_hydrate(data, opts) when is_list(opts) do
    hydrate = Keyword.get(opts, :hydrate, false)

    do_hydrate(data, hydrate)
  end

  defp do_hydrate(data, true), do: Hydratable.hydrate(data)
  defp do_hydrate(data, false), do: data

  defp do_hydrate(data, virtual_fields) when is_list(virtual_fields) do
    case virtual_fields do
      [] -> data
      _ -> Hydratable.hydrate(data, virtual_fields)
    end
  end
end
