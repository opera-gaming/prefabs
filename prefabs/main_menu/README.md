# main_menu

Keyboard and mouse menu — arrows or hover to select, Space or click to confirm.

## The one line worth not deleting

Hover only takes the selection when the mouse **moved this frame**:

```gml
if (_p.x != last_mouse.x || _p.y != last_mouse.y) { ... }
```

Without that gate, arrow-key navigation snaps back to whatever item the
resting cursor happens to sit over, on every single step. It looks like a
bug in the keyboard handling and it is not. Anyone simplifying this file
will be tempted to remove it.

## What comes from where

Hit-testing, hover state and layout are `::ui_board::` — a prefab, so you
call it rather than reading it. Selection, wrapping and what each item
does are in the object this prefab gave you, because those are the parts
you change.
