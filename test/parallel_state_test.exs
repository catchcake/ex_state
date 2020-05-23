defmodule ParallelStateTest do
  @moduledoc false
  use ExUnit.Case

  alias ExState.Machine

  @definition %{
    id: "file",
    type: :parallel,
    states: %{
      upload: %{
        initial: :idle,
        states: %{
          idle: %{
            on: %{
              INIT_UPLOAD: :pending
            }
          },
          pending: %{
            on: %{
              UPLOAD_COMPLETE: :success
            }
          },
          success: %{}
        }
      },
      download: %{
        initial: :idle,
        states: %{
          idle: %{
            on: %{
              INIT_DOWNLOAD: :pending
            }
          },
          pending: %{
            on: %{
              DOWNLOAD_COMPLETE: :success
            }
          },
          success: %{}
        }
      }
    }
  }

  test "should have proper state value" do
    %Machine{state: state} = Machine.create(@definition)

    assert state.value == %{upload: :idle, download: :idle}
  end
end
