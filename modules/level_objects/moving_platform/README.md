## Moving platform

This node moves its parent node when it receives a signal.

### How to set up this node

The node expects a Node3D parent, which will be the object to move.
The destination passed as an export should also be any type extending Node3D,
like for instance a Marker3D.

In order to use the node, you should call its methods:

* `travel_to_destination`: makes the parent node travel towards the destination
* `travel_to_origin`: makes the parent node travel towards the origin
* `travel_toggle`: if the node is currently in the origin or moving towards the
origin, it will travel towards the destination. If it is in the destination or
traveling towards the destination, it will travel towards the origin instead.

The intended way to use these methods is to call them with a signal, but they
can be used from a script or an animation too if needed.
