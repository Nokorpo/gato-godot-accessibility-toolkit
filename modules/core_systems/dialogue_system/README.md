## Dialogue System

This is a simple dialogue system to be used in multiple demos. It contains:

- autoload to call dialogues
- model to define dialogues with resources
- dialogue ui with the possibility to use a 3d avatar with animations
- dialogue trigger to hold a dialogue resource and launch it when the
    character touches it.

### How to set it up

You can either call the autoload `DialogueSystem`'s method `load_dialogue`
from a script, or you can use the `DialogueTrigger` node to do so. This
`DialogueTrigger` node launches a dialogue when the character gets inside an
`Area3D` node.

### How to write a dialogue

In order to write a dialogue, you will need to create a Resource of the type
`DialogueContainer`. Then you can add messages to its list of messages through
the editor's interface.

Each message contains the following variables:

* `name`: the name of the character
* `message`: the text the character will say
* `mesh`: the mesh of the character. This will be loaded once per dialogue and
    it will be reused for all messages in the current dialogue in order to
    save memory
* `animation`: the name of the animation to play
* `face`: the name of the face the character will switch to

