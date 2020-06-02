# Parallel State Nodes

A parallel state node represents multiple _orthogonal_ child state nodes; that is, a parallel state is in _all_ of its child states at the same time. The key word here is **parallel** (or orthogonal) - the states are not directly dependent on each other, and no transitions should exist between parallel state nodes.

A parallel state node is specified on the machine and/or any nested compound state by setting `type: 'parallel'`.
