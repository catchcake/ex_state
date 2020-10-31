defmodule ExState.Machine do
  @moduledoc """
  A finite state machine definition.
  """

  alias ExState.{Event, State, Options, Request, States}

  defstruct id: nil,
            initial: nil,
            context: nil,
            state: nil,
            states: %{},
            options: nil

  def create(machine, opts \\ %{}) when is_map(machine) and is_map(opts) do
    %__MODULE__{}
    |> put_id(machine)
    |> put_initial(machine)
    |> put_context(machine)
    |> create_states(machine)
    |> put_options(opts)
    |> transition(:ex_state_init)
  end

  # def transition(%__MODULE__{} = machine, event) do
  #   machine
  #   |> Request.create(Event.create(event))
  #   |> move()
  # end

  def transition(%__MODULE__{} = machine, event) do
    request = %{
      machine: machine
    }

    request
    |> Event.create(event)
    |> State.move()
  end

  def context(%__MODULE__{state: state}) do
    State.context(state)
  end

  def state(%__MODULE__{state: state}) do
    State.value(state)
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

  defp put_options(%__MODULE__{} = machine, opts) when is_map(opts) do
    %__MODULE__{machine | options: Options.create(opts)}
  end

  defp create_states(%__MODULE__{} = machine, %{states: states}) when is_map(states) do
    %__MODULE__{machine | states: States.create(states)}
  end

  defp move(%Request{machine: machine} = request) do
    %__MODULE__{machine | state: State.move(request)}
  end
end
