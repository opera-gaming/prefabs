# isometric_basics

A diamond grid you can hover and pan, with correct depth sorting.

## Measure your tileset before trusting any number

`tile_h` is the height of the **diamond alone**, not of the sprite. A tile
sprite usually draws a vertical skirt below its diamond so that walls and
cliffs have thickness, which makes the sprite taller than the cell it
occupies.

Use the sprite height and every neighbouring tile overlaps slightly —
seams open along one diagonal and not the other, which is why this bug is
so hard to see in a screenshot of a single tile. For a 180×125 sprite with
a 52px skirt, `tile_h` is 73.

Tune the sprite origin and `tile_h` together, on a grid of at least 3×3,
and look at the joins rather than the tiles.

## Depth

Instances standing on the grid need `::iso::iso_depth(col, row)` as their
depth, or a tile's skirt will draw over an actor that is in front of it.
Tiles drawn in a row-major loop need no sorting — the loop order is
already back-to-front.

## What comes from where

The projection and its inverse are `::iso::` — invariant maths you call.
Which tiles, how the camera pans, and what a cell contains are in the
object this prefab gave you.
