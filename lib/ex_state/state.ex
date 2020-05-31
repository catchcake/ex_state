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

  def move(%Request{transition: nil, event: event, context: context, machine: machine}) do
    %__MODULE__{
      value: machine.state.value,
      event: event,
      context: context
    }
  end

  def move(%Request{actions: actions, transition: transition, event: event, context: context}) do
    %__MODULE__{
      value: Transition.target(transition),
      event: event,
      context: run_side_effects(actions, context, event)
    }
  end

  defp run_side_effects([], context, _event) do
    context
  end

  defp run_side_effects([{:assign, f} | rest], context, event) when is_function(f, 2) do
    run_side_effects(rest, f.(context, event), event)
  end

  defp run_side_effects([f | rest], context, event) when is_function(f, 2) do
    f.(context, event)
    run_side_effects(rest, context, event)
  end
end
