defmodule MachineTest do
  @moduledoc false
  use ExUnit.Case
  doctest ExState.Machine

  alias ExState.Machine

  @definition
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

  test "my test description" do
    assert false
  end
end
