# falling_block

A whole falling-block game — seven pieces, wall kicks, line clears, speed ramp.

## What you change first

**The pieces.** All seven are data in `prefab.toml` — a colour and a list
of cells each, not seven branches of code. Add an eighth by adding a row;
rotation is computed about the piece centre, so an asymmetric piece needs
no special case.

**The feel.** `fall_interval`, `speed_ramp`, `soft_drop` and
`points_per_row` are tuning knobs. Clearing several rows at once scores
the row count squared, which is what makes going for four worth the risk.

## What you do not have to maintain

The board — cell/pixel conversion, neighbour queries, full-row detection,
collapse, and snapshot/restore for undo — is `::grid::`. Score and combo
are `::kernel::`. Hit-stop, shake and the popups are `::feel::`.

## The one part worth reading before you change it

Rows are collapsed **bottom-up**. Removing an upper row first shifts the
indices of the ones still to remove, and a four-line clear silently
becomes a three-line clear.
