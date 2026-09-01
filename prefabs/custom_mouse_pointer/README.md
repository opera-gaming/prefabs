# custom_mouse_pointer

Replace the OS cursor with something you draw in GUI space.

## The decision this makes for you

It draws in **Draw_GUI**, which is screen space. That is right for a
cursor and wrong for an in-world reticle: `mouse_x`/`mouse_y` are *room*
coordinates, so the moment your room has a camera that moves, anything
drawn from them drifts away from the pointer. If you want a reticle that
sits in the world, move the drawing to `Draw` and use `mouse_x`/`mouse_y`
directly — but then it scrolls with the room, which is usually not what a
cursor should do.

## Swapping in a sprite

```
gmx prefab add incidentals_fantasy/sprites/spr_hand --centre-origin
```

`--centre-origin` matters: catalog sprites usually ship `top_left`, and a
cursor whose hotspot is its corner feels subtly wrong to click with.
Replace the `draw_primitive` block with `draw_sprite_ext`, deriving the
scale from `sprite_get_width` rather than hard-coding it so the sprite can
be swapped without retuning.
