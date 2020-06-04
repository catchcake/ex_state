# Getting Started

Suppose we want to model a simple semaphore as state machine. First, install ExState:

```elixir
def deps do
  [
    {:ex_state, "~> 2.0.1"}
  ]
end
```

```bash
mix deps.get
```

Then, in your project:

```elixir
semaphore = ExState.machine(...);
```

We'll pass the [machine configuration](./machines.html#configuration) inside of `ExState.machine(...)`. Since this is a [hierarchical machine](./hierarchical.html), we need to provide the:

- `id` - to identify the machine and set the base string for its child state node IDs
- `initial` - to specify the initial state node this machine should be in
- `states` - to define each of the child states:

```elixir
semaphore = ExState.machine(%{
  id: "semaphore",
  initial: :red,
  states: %{
    red: %{},
    green: %{}
  }
})
```

Then, we need to add [transitions](./transitions.html) to the state nodes:

```elixir
semaphore = ExState.machine({
  id: "semaphore",
  initial: :red,
  states: %{
    red: %{
      on: %{
        switch: %{target: :green}
      }
    },
    green: %{
      on: %{
        switch: %{target: :red}
      }
    }
  }
});
```

and now make some transtion to next states:

```elixir
semaphore.state.value == :red
semaphore = ExState.transtion(semaphore, :switch)
semaphore.state.value == :green

# and back
semaphore = ExState.transtion(semaphore, :switch)
semaphore.state.value == :red
```
