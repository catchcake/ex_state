defmodule ExState.Event do
  @moduledoc """
  An event structure.
  """

  defstruct type: nil,
            data: nil

  def create(request, %{type: type, data: data}) when is_map(request) do
    Map.put(request, :event, %__MODULE__{type: type, data: data})
  end

  def create(request, event) when is_map(request) and (is_binary(event) or is_atom(event)) do
    Map.put(request, :event, %__MODULE__{type: event, data: nil})
  end
end
