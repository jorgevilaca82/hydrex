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
