# camera-shake

A gmx library prefab for `camera_shake()`. Applies a screen shake effect to the
camera over a given duration, with separate magnitudes for the red, green, and
blue colour channels (an RGB-split displacement that decays as the shake
progresses).

## Quick usage

Drop the following into any triggered event to shake the screen:

```gml
camera_shake(0.75, 0.1, 0.15, 0.25);
```

## How it works

`camera_shake()` is the only entry point. The first call creates an internal
`obj_camera_shake` instance behind the scenes and configures it with
`shake_length` and `shake_mag`; while a shake is active, further calls are
ignored until it finishes. You never need to place `obj_camera_shake` in a room
— just call the function from any event when you want the shake to start.

Each frame the controller captures the rendered scene to a surface (Pre-Draw),
advances its timer, and re-draws the surface through `shdr_camera_shake` on
Draw-GUI-End. When the timer passes `shake_length` the instance destroys itself.

**Internal instance variables (set by `camera_shake()`; you don't assign these
directly):**

- `shake_length` – seconds the shake will last for.
- `shake_mag` – `[r, g, b]` magnitudes per colour channel.

## API reference

### `camera_shake(time, mag_r, mag_g, mag_b)`

Applies a screen shake effect to the camera over a given duration, with separate
magnitudes for the red, green, and blue colour channels.

**Parameters:**
- `time` *(number)* – Duration of the shake effect in seconds.
- `mag_r` *(number)* – Shake magnitude for the red colour channel.
- `mag_g` *(number)* – Shake magnitude for the green colour channel.
- `mag_b` *(number)* – Shake magnitude for the blue colour channel.

## Notes

- Only one camera shake runs at a time.

## Demo

The `rm_demo` room (demo-only, not part of the importable library) shows the
effect: a nebula backdrop with drifting gold asteroids and a prompt — click
anywhere to trigger a shake and an explosion sound.

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file
for details.
