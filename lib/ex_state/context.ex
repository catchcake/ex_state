defmodule ExState.Context do
  @moduledoc """
  A context helpers
  """

  def assign(assigner) when is_map(assigner) do
    {:assign, &update(assigner, &1, &2)}
  end

  defp update(assigner, context, event) do
    Enum.reduce(assigner, context, fn {key, f}, acc -> Map.put(acc, key, f.(context, event)) end)
  end
end
