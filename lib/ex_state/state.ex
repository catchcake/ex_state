defmodule ExState.State do
  @moduledoc """
  A FSM state
  """

  defstruct value: nil

  def create(state) do
    %__MODULE__{value: state}
  end
end
