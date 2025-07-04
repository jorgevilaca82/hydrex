defprotocol Hydrex.Hydratable do
  @doc """
  Hydrates an Ecto struct or a list of structs.
  """
  @fallback_to_any true
  def hydrate(data)
end

defimpl Hydrex.Hydratable, for: Any do
  def hydrate(%{__struct__: struct} = data) do
    case get_virtual_fields(struct) do
      [] -> data
      virtual_fields -> hydrate_virtual_fields(virtual_fields, struct, data)
    end
  end

  def hydrate(data), do: data

  defp hydrate_virtual_fields(virtual_fields, struct, data) do
    Enum.reduce(virtual_fields, data, fn field, acc ->
      case field_resolver(struct, field, acc) do
        nil -> acc
        value -> Map.put(acc, field, value)
      end
    end)
  end

  defp get_virtual_fields(struct) do
    case function_exported?(struct, :__schema__, 1) do
      true -> struct.__schema__(:virtual_fields)
      _ -> []
    end
  end

  defp field_resolver(struct, field, data) do
    case function_exported?(struct, field, 1) do
      true -> apply(struct, field, [data])
      _ -> nil
    end
  end
end

defimpl Hydrex.Hydratable, for: List do
  alias Hydrex.Hydratable

  def hydrate(list), do: Enum.map(list, &Hydratable.hydrate/1)
end
