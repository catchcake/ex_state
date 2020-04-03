defmodule ExState.Transitions do
  @moduledoc """
  State transitions are defined on state nodes, in the `on` key.
  """

  alias ExState.Transition

  def create(transitions) when is_map(transitions) do
    Enum.reduce(
      transitions,
      %{},
      fn {key, value}, acc -> Map.put(acc, key, Transition.create(value)) end
    )
  end
end
