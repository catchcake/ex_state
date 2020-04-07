defmodule ExState.State do
  @moduledoc """
  A FSM state
  """

  alias ExState.{Request, Transition}

  defstruct value: nil,
            event: nil,
            context: nil

  def create(state, context, event) do
    %__MODULE__{value: state, event: event, context: context}
  end

  def value(%__MODULE__{value: value}), do: value

  def context(%__MODULE__{context: context}), do: context

  def move(%Request{transition: transition, event: event, context: context} = request) do
    run_side_effects(request)

    %__MODULE__{
      value: Transition.target(transition),
      event: event,
      context: context
    }
  end

  defp run_side_effects(%Request{context: context, actions: actions, event: event}) do
    Enum.map(actions, fn action -> action.(context, event) end)
  end
end
