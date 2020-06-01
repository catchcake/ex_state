defmodule GuardTest do
  @moduledoc false
  use ExUnit.Case

  alias ExState.{Event, Machine, Context}

  test "should move to next state if guard allow it" do
    definition = %{
      id: "test",
      initial: :init,
      states: %{
        init: %{
          on: %{
            NEXT: %{
              target: :another,
              cond: :next_allowed
            }
          }
        },
        another: %{
          type: :final
        }
      }
    }

    opts = %{
      guards: %{
        next_allowed: fn _context, _event -> true end
      }
    }

    %Machine{state: state} =
      definition
      |> Machine.create(opts)
      |> Machine.transition(:NEXT)

    assert state.value == :another
    assert state.event == Event.create(:NEXT)
  end

  test "should move to first allowed state" do
    context = %{
      ran: nil
    }

    definition = %{
      id: "test",
      initial: :init,
      context: context,
      states: %{
        init: %{
          on: %{
            NEXT: [
              %{
                target: :another,
                cond: :first,
                actions: [:first]
              },
              %{
                target: :another,
                cond: :second,
                actions: [:second]
              },
              %{
                target: :another,
                actions: [:last]
              }
            ]
          }
        },
        another: %{
          type: :final
        }
      }
    }

    opts = %{
      guards: %{
        first: fn _, _ -> false end,
        second: fn _, _ -> true end
      },
      actions: %{
        first: Context.assign(%{ran: fn _, _ -> :first end}),
        second: Context.assign(%{ran: fn _, _ -> :second end}),
        last: Context.assign(%{ran: fn _, _ -> :last end})
      }
    }

    %Machine{state: state} =
      definition
      |> Machine.create(opts)
      |> Machine.transition(:NEXT)

    assert state.value == :another
    assert state.event == Event.create(:NEXT)
    assert state.context == %{ran: :second}
  end

  test "should not move to next state if guard disallow it" do
    definition = %{
      id: "test",
      initial: :init,
      states: %{
        init: %{
          on: %{
            NEXT: %{
              target: :another,
              cond: :next_disallowed
            }
          }
        },
        another: %{
          type: :final
        }
      }
    }

    opts = %{
      guards: %{
        next_disallowed: fn _context, _event -> false end
      }
    }

    %Machine{state: state} =
      definition
      |> Machine.create(opts)
      |> Machine.transition(:NEXT)

    assert state.value == :init
    assert state.event == Event.create(:NEXT)
  end
end
