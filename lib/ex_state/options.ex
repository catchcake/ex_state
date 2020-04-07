defmodule ExState.Options do
  @moduledoc """
  A state machines options
  """

  defstruct actions: %{},
            guards: %{}

  def create(opts) when is_map(opts) do
    %__MODULE__{
      actions: Map.get(opts, :actions, nil),
      guards: Map.get(opts, :guards, nil)
    }
  end

  def action(%__MODULE__{actions: actions}, action), do: Map.fetch!(actions, action)
  def guard(%__MODULE__{guards: guards}, guard), do: Map.fetch!(guards, guard)
end
