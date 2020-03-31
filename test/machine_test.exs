defmodule MachineTest do
  @moduledoc false
  use ExUnit.Case
  doctest ExState.Machine

  alias ExState.Machine

  @definition """
  %{
    id: "fetch",
    initial: :idle,
    states: %{
      idle: %{
        type: :atomic,
        on: %{
          FETCH: :pending
        }
      },
      pending: %{
        type: :parallel,
        states: %{
          resource1: %{
            type: :compound,
            initial: :pending,
            states: %{
              pending: %{
                on: %{
                  "FULFILL.resource1" => :success
                }
              },
              success: %{
                type: :final
              }
            }
          },
          resource2: %{
            type: :compound,
            initial: :pending,
            states: %{
              pending: %{
                on: %{
                  "FULFILL.resource2" => :success
                }
              },
              success: %{
                type: :final
              }
            }
          }
        },
        onDone: :success
      },
      success: %{
        type: :compound,
        initial: :items,
        states: %{
          items: %{
            on: %{
              "ITEM.CLICK" => :item
            }
          },
          item: %{
            on: %{
              BACK: :items
            }
          },
          hist: %{
            type: :history,
            history: :shallow
          }
        }
      }
    }
  }
  """

  test "should create move machine to initial state" do
    definition = %{
      id: "test",
      initial: :init,
      states: %{
        init: %{
          type: :final
        }
      }
    }

    %Machine{state: state} = Machine.create(definition)

    assert state.value == :init
    assert state.event == %{type: :ex_state_init}
  end

  test "should move to next state" do
    definition = %{
      id: "test",
      initial: :init,
      states: %{
        init: %{
          on: %{
            NEXT: :another
          }
        },
        another: %{
          type: :final
        }
      }
    }

    %Machine{state: state} =
      definition
      |> Machine.create()
      |> Machine.transition(:NEXT)

    assert state.value == :another
    assert state.event == %{type: :NEXT}
  end
end