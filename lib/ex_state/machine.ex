defmodule ExState.Machine do
  @moduledoc """
  A finite state machine definition.
  """

  alias ExState.{Event, State, Request, States, Transition}

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

  def transition(%__MODULE__{} = machine, event) do
    machine
    |> Request.create(Event.create(event))
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

  defp move(%Request{machine: machine} = request) do
    %__MODULE__{machine | state: State.move(request)}
  end
end
