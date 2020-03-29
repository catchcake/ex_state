defmodule ExState.NodeType.Final do
  @moduledoc """
  A final state node
  """
  defstruct []

  def create(_) do
    %__MODULE__{}
  end
end
