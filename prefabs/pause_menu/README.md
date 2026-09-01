# pause_menu

Freeze the room, snapshot the screen, dim it, and resume on a key.

## Two approaches, and you must pick one

This is the whole content of this page. Running both means two pause
states that disagree.

**Freeze** — what this prefab applies. `instance_deactivate_all` stops
every instance, so nothing in your game has to know pause exists. The
screen is captured to a surface first, because a deactivated room draws
nothing. Costs: deactivated instances do not run alarms or animations, and
anything that must keep going (a background shader, a music visualiser)
has to be excluded by hand.

**Keep running** — what `::kernel::` already does. The room keeps
simulating and every system gates on `::kernel::kernel_playing()`. Costs:
every gameplay object must check it, and one that forgets keeps moving
behind the pause overlay. Benefit: animations continue, and you can pause
mid-transition without artefacts.

Freeze suits an action game where the pause is a full stop. Keep-running
suits anything with live presentation behind the menu.

## What the snapshot does and does not capture

`application_surface` holds the **world** — everything drawn in `Draw`.
Anything drawn in `Draw_GUI` is composited afterwards and is *not* in it.

So a game whose HUD, menus or debug text live in `Draw_GUI` will freeze
correctly and then show a snapshot missing all of them, because the
deactivated instances are no longer drawing their GUI either. If that
matters, draw the frozen HUD yourself in the pause overlay, or move the
parts that must persist into `Draw`.

This is easy to mistake for a broken snapshot. Check by pausing a room
that draws something in `Draw` — if that survives and the GUI does not,
this is what you are seeing.

## Blurring instead of dimming

Blur the snapshot **once**, when the pause opens — not every frame. A
few passes at a small radius reads as depth; one pass at a large radius
reads as pixelation.
