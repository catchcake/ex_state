defmodule ExState.State do
  @moduledoc """
  A FSM state
  """

  defstruct value: nil,
            event: nil

  def create(state, event) do
    %__MODULE__{value: state, event: event}
  end
end
