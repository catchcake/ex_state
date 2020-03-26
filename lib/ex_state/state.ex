defmodule ExState.State do
  @moduledoc """
  A FSM state
  """

  @type type() :: :atomic | :compound | :parallel | :final | :history

  defmodule Atomic do
    @moduledoc """
    An atomic state node
    """
    defstruct on: %{}
  end

  defmodule Compound do
    @moduledoc """
    A compound state node
    """
    defstruct initial: nil,
              on: %{},
              states: %{}
  end

  defmodule Parallel do
    @moduledoc """
    A parallel state node
    """
    defstruct on: %{},
              states: %{}
  end

  defmodule Final do
    @moduledoc """
    A final state node
    """
    defstruct []
  end

  defmodule History do
    @moduledoc """
    A history state node
    """
    defstruct []
  end
end
