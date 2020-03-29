defmodule ExState.NodeType.Atomic do
  @moduledoc """
  An atomic state node
  """
  defstruct on: %{}

  def create(%{on: on}) do
    %__MODULE__{
      on: on
    }
  end
end
