# music_and_sfx

Looping music that survives room changes, plus one-shot effects.

## The decision this makes for you

**Compression mode, per sound.** This is the choice that actually matters
and the generator cannot make it, because it depends on the asset:

- A multi-minute music track wants `compression = "streamed"`. Left
  uncompressed it sits in RAM in full — tens of megabytes for one song.
- A short effect wants uncompressed. Streamed, it decodes on play, and the
  latency is audible on something that has to land on a hit frame.

Set it in the sound's `sound.toml` after adding it.

## Adding a track

```
gmx prefab add track_and_street_racer/sounds/OGG_Racing_Track1
```

Prefab resources are namespaced, so it is
`::track_and_street_racer::OGG_Racing_Track1` in GML, not the bare name.
Pass it to `music_play`.
