defmodule ExState.Transition do
  @moduledoc """
  A state transition defines what the next state is.
  """

  defstruct target: nil,
            cond: nil,
            actions: []

  def create(value) when is_atom(value) or is_binary(value) do
    create(%{target: value})
  end

  def create(value) when is_list(value) do
    Enum.map(value, &create/1)
  end

  def create(value) when is_map(value) do
    %__MODULE__{
      target: value.target,
      cond: Map.get(value, :cond, nil),
      actions: Map.get(value, :actions, [])
    }
  end

  def target(%__MODULE__{target: target}), do: target
  def actions(%__MODULE__{actions: actions}), do: actions
  def guard(%__MODULE__{cond: guard}), do: guard
end
