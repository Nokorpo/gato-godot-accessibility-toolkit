## Button

A button that detects PhysicBodies touching it. 

It is mainly interacted with the signals it emits:

* `button_activated`: when a body activates the button
* `button_deactivated`: when a body stops touching the button and it's deactivated
* `button_toggled(toggle: bool)`: when the button state changes. The `toggle` parameter
represents the state (`true` for activated, `false` for deactivated.)
