defmodule Hydrex.Hydratable.Utils do
  alias Hydrex.Hydratable

  def maybe_hydrate(data, opts) do
    hydrate = Keyword.get(opts, :hydrate, false)

    case hydrate do
      true -> Hydratable.hydrate(data)
      false -> data
    end
  end
end
