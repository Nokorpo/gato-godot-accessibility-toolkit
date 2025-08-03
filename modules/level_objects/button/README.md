## Button

A button that detects PhysicBodies touching it. 

It is mainly interacted with the signals it emits:

* `button_activated`: when a body activates the button
* `button_deactivated`: when a body stops touching the button and it's deactivated
* `button_toggled(toggle: bool)`: when the button state changes. The `toggle` parameter
represents the state (`true` for activated, `false` for deactivated.)

### Create objects to press the button

If you need to create a new object that presses the button, you should:

1. Create a PhysicsBody3D object
2. Give it a CollisionShape
3. Add either the `light_weight` and/or `heavy_weight` group to it

That's it, the item should activate the button
