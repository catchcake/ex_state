defmodule ExState.NodeType do
  @moduledoc """
  A state node specifies a state configuration.
  """

  @type type() :: :atomic | :compound | :parallel | :final | :history

  defmodule InvalidNodeError do
    @moduledoc false

    defexception [:message]

    @impl true
    def exception(value) do
      %__MODULE__{message: "Proper state node not found, got: #{inspect(value)}"}
    end
  end

  defmodule Atomic do
    @moduledoc """
    An atomic state node
    """
    defstruct on: %{}

    def create(%{on: on}) do
      %__MODULE__{
        on: on
      }
    end
  end

  defmodule Compound do
    @moduledoc """
    A compound state node
    """
    defstruct initial: nil,
              on: %{},
              states: %{}

    def create(%{initial: init, states: states} = node) do
      %__MODULE__{
        initial: init,
        on: Map.get(node, :on, %{}),
        states: ExState.States.create(states)
      }
    end
  end

  defmodule Parallel do
    @moduledoc """
    A parallel state node
    """
    defstruct on: %{},
              states: %{}

    def create(%{states: states} = node) when map_size(states) > 1 do
      %__MODULE__{
        on: Map.get(node, :on, %{}),
        states: ExState.States.create(states)
      }
    end
  end

  defmodule Final do
    @moduledoc """
    A final state node
    """
    defstruct []

    def create(_) do
      %__MODULE__{}
    end
  end

  defmodule History do
    @moduledoc """
    A history state node
    """
    defstruct history: :shallow,
              target: nil

    def create(node) when is_map(node) do
      %__MODULE__{}
      |> put_history(Map.get(node, :history, :shallow))
      |> put_target(Map.get(node, :target, nil))
    end

    defp put_history(%__MODULE__{} = node, history) when history in [:shallow, :deep] do
      %__MODULE__{node | history: history}
    end

    defp put_target(%__MODULE__{} = node, target) do
      %__MODULE__{node | target: target}
    end
  end

  def create(%{type: :atomic} = node) do
    Atomic.create(node)
  end

  def create(%{type: :compound} = node) do
    Compound.create(node)
  end

  def create(%{type: :parallel, states: states} = node) do
    Parallel.create(node)
  end

  def create(%{type: :final} = node) do
    Final.create(node)
  end

  def create(%{type: :history} = node) do
    History.create(node)
  end

  def create(%{initial: _, states: states} = node) when map_size(states) > 0 do
    Compound.create(node)
  end

  def create(node) when is_map(node) do
    if Map.has_key?(node, :states) do
      raise InvalidNodeError, node
    end

    Atomic.create(node)
  end
end
