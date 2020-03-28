defmodule ExState.Machine do
  @moduledoc """
  A finite state machine definition.
  """

  alias ExState.{State, States}

  defstruct id: nil,
            initial: nil,
            state: %State{},
            states: %{}

  def create(machine) when is_map(machine) do
    %__MODULE__{}
    |> put_id(machine)
    |> put_initial(machine)
    |> create_states(machine)
    |> init()
  end

  # def transition(%__MODULE__{} = machine, event) do
  # end

  # Private
  defp put_id(%__MODULE__{} = machine, %{id: id}) when is_binary(id) do
    %__MODULE__{machine | id: id}
  end

  defp put_initial(%__MODULE__{} = machine, %{initial: init})
       when is_atom(init) or is_binary(init) do
    %__MODULE__{machine | initial: init}
  end

  defp create_states(%__MODULE__{} = machine, %{states: states}) when is_map(states) do
    %__MODULE__{machine | states: States.create(states)}
  end

  defp init(%__MODULE__{initial: init} = machine) do
    %__MODULE__{machine | state: State.create(init)}
  end
end
