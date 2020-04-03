defmodule ExState.NodeType.Compound do
  @moduledoc """
  A compound state node
  """
  alias ExState.Transitions

  defstruct initial: nil,
            on: %{},
            states: %{}

  def create(%{initial: init, states: states} = node) do
    %__MODULE__{
      initial: init,
      on: node |> Map.get(:on, %{}) |> Transitions.create(),
      states: ExState.States.create(states)
    }
  end
end
