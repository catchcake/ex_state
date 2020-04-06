defmodule MachineTest do
  @moduledoc false
  use ExUnit.Case
  doctest ExState.Machine

  alias ExState.{Event, Machine}

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
    assert state.event == Event.create(:ex_state_init)
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
    assert state.event == Event.create(:NEXT)
  end

  test "should run defined action" do
    context = %{test: 12_345}

    definition = %{
      id: "test",
      initial: :init,
      context: context,
      states: %{
        init: %{
          on: %{
            NEXT: %{
              target: :another,
              actions: [:test]
            }
          }
        },
        another: %{
          type: :final
        }
      }
    }

    opts = %{
      actions: %{
        test: &test_action/2
      }
    }

    %Machine{state: state} =
      definition
      |> Machine.create(opts)
      |> Machine.transition(:NEXT)

    assert state.value == :another
    assert state.event == Event.create(:NEXT)

    assert_receive {:action_called, ^context, %{type: :NEXT}}
  end

  defp test_action(context, event) do
    send(self(), {:action_called, context, event})
  end
end
