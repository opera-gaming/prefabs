# rooms_as_state_machines

Title → game → results → loop. The skeleton almost every game starts from.

## The decisions this makes for you

**Rooms as states, not one room with a mode flag.** Rooms give you free
teardown: leaving a room destroys its instances, so state cannot leak
between screens. Use a single room with a state variable instead only when
the screens share heavy live state that is expensive to rebuild — a paused
3D scene behind a menu, say.

**Every room has a Background layer.** This is not decoration. The layer
is what clears the surface each frame; without one, draw calls accumulate
visually and the screen smears.

**State that must survive a transition goes in the kernel**, which is
persistent, or in a global. Instance variables do not survive
`room_goto` — that is the point of using rooms.

## What is already done for you

The run lifecycle, score, combo, save and the high score are
`::kernel::`. This prefab is the three rooms and the three controllers
that move between them; the machinery underneath is not yours to maintain.
