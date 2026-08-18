/// @function transition_defaults()
/// @description Default values for this transition's tunable shader uniforms.
/// Keys are uniform names (as declared in the effect's fragment shader); values
/// are the fallbacks used when goto()'s `params` omits them. goto() merges the
/// caller's params over this struct, so every knob always resolves to a real
/// value — which means 0 is a legal input, not a "use the default" sentinel.
///
/// Derived effects override this file (just like they override the fragment
/// shader) to expose their knobs. This base "fade" effect has no tunable
/// uniforms, so it returns an empty struct.
function transition_defaults() {
    return {};
}
