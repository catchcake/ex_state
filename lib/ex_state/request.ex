defmodule ExState.Request do
  @moduledoc """
  A transition request.
  """

  alias ExState.{Machine, Event, Options, Transition, State}

  defstruct machine: nil,
            event: nil,
            context: nil,
            current_state: nil,
            transition: nil,
            next_state: nil,
            actions: []

  def create(%Machine{} = machine, %Event{} = event) do
    %__MODULE__{}
    |> put_event(event)
    |> put_machine(machine)
    |> put_context()
    |> put_current_state()
    |> put_transition()
    |> put_next_state()
    |> put_actions()
  end

  defp put_context(
         %__MODULE__{event: %Event{type: :ex_state_init}, machine: %Machine{context: context}} =
           request
       ) do
    %__MODULE__{request | context: context}
  end

  defp put_context(%__MODULE__{machine: %Machine{state: state}} = request) do
    %__MODULE__{request | context: State.context(state)}
  end

  defp put_next_state(%__MODULE__{transition: nil} = request) do
    %__MODULE__{request | next_state: nil}
  end

  defp put_next_state(%__MODULE__{machine: %Machine{states: states}} = request) do
    %__MODULE__{
      request
      | next_state: Map.fetch!(states, Transition.target(request.transition))
    }
  end

  defp put_current_state(%__MODULE__{event: %Event{type: :ex_state_init}} = request) do
    %__MODULE__{request | current_state: nil}
  end

  defp put_current_state(%__MODULE__{machine: %Machine{states: states, state: state}} = request) do
    %__MODULE__{request | current_state: Map.fetch!(states, State.value(state))}
  end

  defp put_transition(
         %__MODULE__{event: %Event{type: :ex_state_init}, machine: %Machine{initial: init}} =
           request
       ) do
    %__MODULE__{request | transition: Transition.create(init)}
  end

  defp put_transition(%__MODULE__{event: event, current_state: current_state} = request) do
    %__MODULE__{
      request
      | transition:
          current_state.on
          |> Map.fetch!(event.type)
          |> normalize_transitions()
          |> find_first_allowed_transition(request)
    }
  end

  defp normalize_transitions(%Transition{} = transition) do
    [transition]
  end

  defp normalize_transitions(transitions) when is_list(transitions) do
    transitions
  end

  defp find_first_allowed_transition([%Transition{cond: nil} = transition | _], _) do
    transition
  end

  defp find_first_allowed_transition(
         [%Transition{cond: guard} = transition | rest],
         request
       ) do
    guard_function = Options.guard(request.machine.options, guard)

    if guard_function.(request.context, request.event) do
      transition
    else
      find_first_allowed_transition(rest, request)
    end
  end

  defp find_first_allowed_transition([], _) do
    nil
  end

  defp put_event(%__MODULE__{} = request, %Event{} = event) do
    %__MODULE__{request | event: event}
  end

  defp put_machine(%__MODULE__{} = request, %Machine{} = machine) do
    %__MODULE__{request | machine: machine}
  end

  defp put_actions(%__MODULE__{transition: nil} = request) do
    %__MODULE__{request | actions: nil}
  end

  defp put_actions(
         %__MODULE__{machine: %Machine{options: opts}, transition: transition} = request
       ) do
    %__MODULE__{
      request
      | actions: transition |> Transition.actions() |> Enum.map(&Options.action(opts, &1))
    }
  end
end
