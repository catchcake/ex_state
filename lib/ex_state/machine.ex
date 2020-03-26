defmodule ExState.Machine do
  @moduledoc """
  A finite state machine definition.
  """

  defstruct id: nil,
            initial: nil,
            states: %{}

  def create(machine) when is_map(machine) do
  end
end
