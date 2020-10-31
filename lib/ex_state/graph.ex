defmodule ExState.Graph do
  @moduledoc """
  A state value helpers.
  """

  def paths(map) when is_map(map) do
    map
    |> Map.to_list()
    |> Enum.map(fn {key, value} -> {[key], value} end)
    |> paths([])
  end

  defp paths([], result) do
    result
    |> Enum.reverse()
    |> Enum.map(&Enum.reverse/1)
  end

  defp paths([{visited_key, map} | rest], result) when is_map(map) do
    map
    |> Map.to_list()
    |> Enum.map(fn {key, value} -> {[key | visited_key], value} end)
    |> Enum.concat(rest)
    |> paths([visited_key | result])
  end

  defp paths([{key, value} | rest], result) do
    paths(rest, [[value | key] | [key | result]])
  end
end
