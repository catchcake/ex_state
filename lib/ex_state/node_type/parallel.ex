defmodule ExState.NodeType.Parallel do
  @moduledoc """
  A parallel state node
  """
  defstruct on: %{},
            states: %{}

  def create(%{states: states} = node) when map_size(states) > 1 do
    %__MODULE__{
      on: Map.get(node, :on, %{}),
      states: ExState.States.create(states)
    }
  end
end
