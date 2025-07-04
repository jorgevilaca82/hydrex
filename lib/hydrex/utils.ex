defmodule Hydrex.Hydratable.Utils do
  alias Hydrex.Hydratable

  @doc """
  Conditionally hydrates the given data.

  If the second argument is a boolean, hydration is performed if it's `true`.
  If the second argument is a keyword list, hydration is performed if `:hydrate` is `true` in the options.
  """
  @spec maybe_hydrate(any(), boolean() | keyword()) :: any()
  def maybe_hydrate(data, true), do: Hydratable.hydrate(data)
  def maybe_hydrate(data, false), do: data

  def maybe_hydrate(data, opts) when is_list(opts) do
    hydrate = Keyword.get(opts, :hydrate, false)

    case hydrate do
      true -> Hydratable.hydrate(data)
      false -> data
    end
  end
end
