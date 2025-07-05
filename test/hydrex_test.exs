defmodule HydrexTest do
  use ExUnit.Case
  doctest Hydrex

  alias HydrexTest.Support.MockSchema
  import Hydrex.Hydratable.Utils

  setup %{} do
    schemas = [
      %MockSchema{name: "Alice", value: 1},
      %MockSchema{name: "Bob", value: 2}
    ]

    {:ok, schemas: schemas}
  end

  test "fills up all virtual fields", %{schemas: schemas} do
    hydrated = schemas |> Hydrex.Hydratable.hydrate()

    for s <- hydrated do
      assert s.virtual_field == "Virtual field for #{s.name}"
      assert s.other_virtual_field == s.value * 2
    end
  end

  test "does not fill up virtual fields when not requested", %{schemas: schemas} do
    hydrated = schemas |> Hydrex.Hydratable.hydrate([:virtual_field])

    for s <- hydrated do
      assert s.virtual_field == "Virtual field for #{s.name}"
      assert s.other_virtual_field == nil
    end

    hydrated = schemas |> Hydrex.Hydratable.hydrate([:other_virtual_field])

    for s <- hydrated do
      assert s.virtual_field == nil
      assert s.other_virtual_field == s.value * 2
    end
  end

  test "maybe_hydrate with true", %{schemas: schemas} do
    hydrated = maybe_hydrate(schemas, true)

    for s <- hydrated do
      assert s.virtual_field == "Virtual field for #{s.name}"
      assert s.other_virtual_field == s.value * 2
    end
  end

  test "maybe_hydrate with false. hydrate anything", %{schemas: schemas} do
    hydrated = maybe_hydrate(schemas, false)

    for s <- hydrated do
      assert s.virtual_field == nil
      assert s.other_virtual_field == nil
    end
  end

  test "maybe_hydrate with options", %{schemas: schemas} do
    hydrated = maybe_hydrate(schemas, hydrate: true)

    for s <- hydrated do
      assert s.virtual_field == "Virtual field for #{s.name}"
      assert s.other_virtual_field == s.value * 2
    end
  end

  test "maybe_hydrate with options. hydrate anything", %{schemas: schemas} do
    hydrated = maybe_hydrate(schemas, hydrate: false)

    for s <- hydrated do
      assert s.virtual_field == nil
      assert s.other_virtual_field == nil
    end

    hydrated = maybe_hydrate(schemas, hydrate: [])

    for s <- hydrated do
      assert s.virtual_field == nil
      assert s.other_virtual_field == nil
    end
  end

  test "maybe_hydrate with options, select fields to hydrate", %{schemas: schemas} do
    hydrated = maybe_hydrate(schemas, hydrate: [:virtual_field])

    for s <- hydrated do
      assert s.virtual_field == "Virtual field for #{s.name}"
      assert s.other_virtual_field == nil
    end

    hydrated = maybe_hydrate(schemas, hydrate: [:other_virtual_field])

    for s <- hydrated do
      assert s.virtual_field == nil
      assert s.other_virtual_field == s.value * 2
    end
  end
end
