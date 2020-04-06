defmodule ExState.Machine do
  @moduledoc """
  A finite state machine definition.
  """

  alias ExState.{Event, State, States, Transition}

  defstruct id: nil,
            initial: nil,
            context: nil,
            state: nil,
            states: %{}

  def create(machine, opts \\ %{}) when is_map(machine) do
    %__MODULE__{}
    |> put_id(machine)
    |> put_initial(machine)
    |> put_context(machine)
    |> create_states(machine)
    |> transition(:ex_state_init)
  end

  def transition(%__MODULE__{initial: init, context: context} = machine, :ex_state_init) do
    %__MODULE__{machine | state: State.create(init, context, Event.create(:ex_state_init))}
  end

  def transition(%__MODULE__{} = machine, event) do
    %{machine: machine, event: Event.create(event)}
    |> current_state()
    |> find_transition()
    |> next_state()
    |> move()
  end

  # Private

  defp put_id(%__MODULE__{} = machine, %{id: id}) when is_binary(id) do
    %__MODULE__{machine | id: id}
  end

  defp put_initial(%__MODULE__{} = machine, %{initial: init})
       when is_atom(init) or is_binary(init) do
    %__MODULE__{machine | initial: init}
  end

  defp put_context(%__MODULE__{} = machine, definition) when is_map(definition) do
    %__MODULE__{machine | context: Map.get(definition, :context, nil)}
  end

  defp create_states(%__MODULE__{} = machine, %{states: states}) when is_map(states) do
    %__MODULE__{machine | states: States.create(states)}
  end

  defp move(transition) do
    %__MODULE__{
      transition.machine
      | state:
          State.create(
            Transition.target(transition.transition),
            transition.machine.context,
            transition.event
          )
    }
  end

  defp next_state(transition) do
    Map.put(
      transition,
      :next_state,
      Map.fetch!(
        transition.machine.states,
        Transition.target(transition.transition)
      )
    )
  end

  defp current_state(%{machine: %__MODULE__{state: %State{value: value}}} = transition) do
    Map.put(transition, :current_state, transition.machine.states |> Map.fetch!(value))
  end

  defp find_transition(%{event: %{type: event}} = transition) do
    Map.put(
      transition,
      :transition,
      Map.fetch!(transition.current_state.on, event)
    )
  end
end
