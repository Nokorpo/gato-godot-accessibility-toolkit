# Demo 3

## Scripting language

Everything in this demo is tied to dialogue and we wanted to be able to configure the gameplay based on the dialogue tree. We implemented a very simple scripting language to drive the animations and dialogue in this demo to do that.

The basics of the scripts are as follows:

* Every line is an instruction
* An instruction is composed of a keyword (the first word) and a text parameter
* All instructions are executed until a `STOP` or `WAIT_FOR_CHOICE` instruction is found

### Instruction list

The list of instructions is as follows:

* `SAY <text>`: change the text in the narrator box to the text parameter. Example: `SAY Hello `
* `STOP`: waits until the player clicks on the narrator box before executing the next instruction. This is necessary after a SAY instruction if you want the player to be able to read the text
* `WAIT_FOR_CHOICE`: similar to the `STOP` instruction, but it waits for the player to click on the attack or dialogue buttons instead of the narrator box
* `PLAY_ANIMATION <animation_name>`: plays an animation in the AnimationPlayer. The animation played will be the one named like the passed parameter. Example: `PLAY_ANIMATION gato_hit`
* `SET_HP <gato|zeta> <0-100>`: animates the hp bar moving (it can go up or down). The accepted values for this instruction are either `gato` or `zeta` for the first parameter and a number between 0 and 100 for the second. Example: `SET_HP gato 50`

### Example script

```
SAY Gato: Zeta, give me my acorns back!
STOP
PLAY_ANIMATION zeta_laugh
SAY Zeta: No way! Go away!
STOP
SAY Zeta throws an acorn at Gato.
STOP
PLAY_ANIMATION gato_hit
SET_HP gato 50
SAY Gato's morale goes down to 50%.
STOP
SAY Gato: Ouch!
STOP
SAY What should I do?
WAIT_FOR_CHOICE
```
