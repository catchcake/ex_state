defmodule ExState do
  @moduledoc """
  Elixir state machines and statecharts

  ## Usage

      iex> definition = %{
      iex>   id: "toggle",
      iex>   initial: :inactive,
      iex>   states: %{
      iex>     inactive: %{
      iex>       on: %{
      iex>         TOGGLE: %{
      iex>           target: :active
      iex>         }
      iex>       }
      iex>     },
      iex>     active: %{
      iex>       on: %{
      iex>         TOGGLE: %{
      iex>           target: :inactive
      iex>         }
      iex>       }
      iex>     }
      iex>   }
      iex> }
      iex> machine = ExState.machine(definition)  # and now create state machine
      iex> ExState.transition(machine, :TOGGLE)  # and transit to new state
      %ExState.Machine{
        context: nil,
        id: "toggle",
        initial: :inactive,
        options: %ExState.Options{actions: nil, guards: nil},
        state: %ExState.State{
          context: nil,
          event: %ExState.Event{data: nil, type: :TOGGLE},
          value: :active
        },
        states: %{
          active: %ExState.NodeType.Atomic{
            on: %{
              TOGGLE: %ExState.Transition{actions: [], cond: nil, target: :inactive}
            }
          },
          inactive: %ExState.NodeType.Atomic{
            on: %{
              TOGGLE: %ExState.Transition{actions: [], cond: nil, target: :active}
            }
          }
        }
      }
  """

  @doc """
  See `ExState.Machine.create/2`
  """
  defdelegate machine(machine, opts \\ %{}), to: ExState.Machine, as: :create

  @doc """
  See `ExState.Machine.transition/2`
  """
  defdelegate transition(machine, event), to: ExState.Machine

  defdelegate state(machine), to: ExState.Machine
  defdelegate context(machine), to: ExState.Machine
end
