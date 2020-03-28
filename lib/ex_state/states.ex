defmodule ExState.States do
  @moduledoc """
  A states creator
  """

  alias ExState.NodeType

  def create(states) when is_map(states) do
    states
    |> Map.to_list()
    |> walk()
  end

  # Private
  defp walk(list, acc \\ %{})

  defp walk([], acc) do
    acc
  end

  defp walk([{key, value} | rest], acc) do
    walk(
      rest,
      Map.put(acc, key, NodeType.create(value))
    )
  end
end
