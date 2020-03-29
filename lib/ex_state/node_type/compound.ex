defmodule ExState.NodeType.Compound do
  @moduledoc """
  A compound state node
  """
  defstruct initial: nil,
            on: %{},
            states: %{}

  def create(%{initial: init, states: states} = node) do
    %__MODULE__{
      initial: init,
      on: Map.get(node, :on, %{}),
      states: ExState.States.create(states)
    }
  end
end
