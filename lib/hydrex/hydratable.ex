defprotocol Hydrex.Hydratable do
  @moduledoc """
  A protocol for hydrating Ecto structs with virtual fields.
  """

  @doc """
  Hydrates an Ecto struct or a list of structs.

  ## Parameters
  - `data`: The Ecto struct or a list of structs to hydrate.
  - `virtual_fields`: A list of virtual fields to hydrate. If empty or omitted, all virtual fields will be hydrated.

  ## Examples

      iex> defmodule User do
      ...>   use Ecto.Schema
      ...>   embedded_schema do
      ...>     field :name, :string
      ...>     field :age, :integer
      ...>     field :greeting, :string, virtual: true
      ...>   end
      ...>   def greeting(%User{name: name}), do: "Hello, \#{name}!"
      ...> end
      iex> user = %User{name: "Alice", age: 30}
      iex> Hydrex.Hydratable.hydrate(user, [:greeting])
      # or `Hydrex.Hydratable.hydrate(user, [])` in order to hydrate all virtual fields
      # or simply: `Hydrex.Hydratable.hydrate(user)`
      %User{name: "Alice", age: 30, greeting: "Hello, Alice!"}

      iex> users = [%User{name: "Bob"}, %User{name: "Carol"}]
      iex> Hydrex.Hydratable.hydrate(users, [:greeting])
      [
        %User{name: "Bob", age: nil, greeting: "Hello, Bob!"},
        %User{name: "Carol", age: nil, greeting: "Hello, Carol!"}
      ]
  """
  @fallback_to_any true
  @spec hydrate(any(), list(atom())) :: any()
  def hydrate(data, virtual_fields \\ [])
end

defimpl Hydrex.Hydratable, for: Any do
  def hydrate(data, virtual_fields \\ [])

  def hydrate(%{__struct__: struct} = data, virtual_fields) do
    virtual_fields =
      case virtual_fields do
        [] ->
          get_virtual_fields(struct)

        virtual_fields when is_list(virtual_fields) and length(virtual_fields) > 0 ->
          virtual_fields
      end

    case virtual_fields do
      [] -> data
      virtual_fields -> hydrate_virtual_fields(virtual_fields, struct, data)
    end
  end

  def hydrate(data, _), do: data

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

  def hydrate(list, virtual_fields \\ []),
    do: Enum.map(list, &Hydratable.hydrate(&1, virtual_fields))
end
