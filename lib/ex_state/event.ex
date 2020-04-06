defmodule ExState.Event do
  @moduledoc """
  An event structure.
  """

  defstruct type: nil,
            data: nil

  def create(%{type: type, data: data} = event) do
    %__MODULE__{type: event, data: data}
  end

  def create(event) when is_binary(event) or is_atom(event) do
    %__MODULE__{
      type: event,
      data: nil
    }
  end
end
