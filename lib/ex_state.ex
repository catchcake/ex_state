defmodule ExState do
  @moduledoc false

  @doc """
  See `ExState.Machine.create/2`
  """
  defdelegate create(machine, opts \\ %{}), to: ExState.Machine

  @doc """
  See `ExState.Machine.transition/2`
  """
  defdelegate transition(machine, event), to: ExState.Machine
end
