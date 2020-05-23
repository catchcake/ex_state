defmodule CompoundStateTest do
  @moduledoc false
  use ExUnit.Case

  alias ExState.Machine

  test "should transit to initial state" do
    definition = %{
      id: "compound",
      initial: :init,
      states: %{
        init: %{
          on: %{
            NEXT: :another
          }
        },
        another: %{
          initial: :idle,
          states: %{
            idle: %{
              on: %{
                END: :finish
              }
            }
          }
        },
        finish: %{type: :final}
      }
    }

    %Machine{state: state} =
      definition
      |> Machine.create()
      |> Machine.transition(:NEXT)

    assert state.value == %{another: :idle}
  end
end
