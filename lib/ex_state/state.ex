defmodule ExState.State do
  @moduledoc """
  A FSM state
  """

  defstruct value: nil,
            event: nil,
            context: nil

  def create(state, context, event) do
    %__MODULE__{value: state, event: event, context: context}
  end
end
