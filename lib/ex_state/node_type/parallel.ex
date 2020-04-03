defmodule ExState.NodeType.Parallel do
  @moduledoc """
  A parallel state node
  """

  alias ExState.Transitions

  defstruct on: %{},
            states: %{}

  def create(%{states: states} = node) when map_size(states) > 1 do
    %__MODULE__{
      on: node |> Map.get(:on, %{}) |> Transitions.create(),
      states: ExState.States.create(states)
    }
  end
end
