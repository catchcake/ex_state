defmodule ExState.NodeType do
  @moduledoc """
  A state node specifies a state configuration.
  """

  alias ExState.NodeType.{Atomic, Compound, Parallel, Final, History}

  @type type() :: :atomic | :compound | :parallel | :final | :history

  defmodule InvalidNodeError do
    @moduledoc false

    defexception [:message]

    @impl true
    def exception(value) do
      %__MODULE__{message: "Proper state node not found, got: #{inspect(value)}"}
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
