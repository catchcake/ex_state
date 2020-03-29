defmodule ExState.NodeType.History do
  @moduledoc """
  A history state node
  """
  defstruct history: :shallow,
            target: nil

  def create(node) when is_map(node) do
    %__MODULE__{}
    |> put_history(Map.get(node, :history, :shallow))
    |> put_target(Map.get(node, :target, nil))
  end

  defp put_history(%__MODULE__{} = node, history) when history in [:shallow, :deep] do
    %__MODULE__{node | history: history}
  end

  defp put_target(%__MODULE__{} = node, target) do
    %__MODULE__{node | target: target}
  end
end
