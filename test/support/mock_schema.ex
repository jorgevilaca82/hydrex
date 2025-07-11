defmodule HydrexTest.Support.MockSchema do
  use Ecto.Schema

  @derive Hydrex.Hydratable
  embedded_schema do
    field(:name, :string)
    field(:value, :integer)
    field(:virtual_field, :string, virtual: true)
    field(:other_virtual_field, :integer, virtual: true)
  end

  def virtual_field(%{name: name}), do: "Virtual field for #{name}"
  def other_virtual_field(%{value: value}), do: value * 2
end
