defmodule ExState.NodeType.Atomic do
  @moduledoc """
  An atomic state node
  """

  alias ExState.Transitions

  defstruct on: %{}

  def create(%{on: on}) do
    %__MODULE__{
      on: Transitions.create(on)
    }
  end
end
