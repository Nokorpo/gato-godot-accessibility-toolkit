## State Machine

This is a state machine implementation that allows representing states as nodes
in the Scene Tree. This might be useful in order to connect nodes to signals on
the scene it's being used on, or to connect other nodes to a signal from a state.

### Components

Its main components are `StateMachine` and `StateMachineState`

`StateMachine` stores a reference to the current state and handles transitioning
between states. You can change to a different state using its
`change_state(state: StateMachineState)` method.

`StateMachineState` handles internal logic for each state. For instance, a
Falling state might move the character down with the gravity.

Moreover, the `StateMachineState` has a script template that can be found in
`res://script_templates/StateMachineState/default_state_machine_state.gd`. You
can select it when creating a script of type StateMachineState to populate


### Tick, process and physics_process

The `StateMachineStates` have 3 ways to run logic periodically. The `_process()`
and `_physics_process()` methods are the same as any other node in Godot. But
you should keep in mind that these methods will be called even when the state is
not active. In order to run logic _only_

The third option is the `tick()` method. This method is called whenever the
`StateMachine`'s `_tick()` method is called. This could be whenever the
simulation "ticks". This could be a turn in a turn-based game, or a `Timer`
that runs every 2 seconds. 
