/// Currency, prices and whether you can afford it.
///
/// `economy_spend` returns whether it went through and only deducts when it
/// did. Checking affordability and deducting as two separate steps is how a
/// balance goes negative — the check passes, something else spends, and the
/// deduction happens anyway.

/// @function economy_make(starting)
/// @description A purse holding `starting` currency, with nothing spent yet.
function economy_make(starting) {
    return { balance: starting, earned: starting, spent: 0 };
}

/// @function economy_balance(purse)
function economy_balance(purse) {
    return purse.balance;
}

/// @function economy_earn(purse, amount)
/// @description Add to the balance. Negative amounts are ignored rather than
/// quietly acting as a spend that skips the affordability check.
function economy_earn(purse, amount) {
    if (amount <= 0) return 0;
    purse.balance += amount;
    purse.earned += amount;
    return amount;
}

/// @function economy_can_afford(purse, price)
function economy_can_afford(purse, price) {
    return purse.balance >= price;
}

/// @function economy_spend(purse, price)
/// @description Deduct `price` only if it is there. Returns whether the
/// purchase happened, so the thing bought is granted on a true and nothing
/// is granted on a false.
function economy_spend(purse, price) {
    if (!economy_can_afford(purse, price)) return false;
    purse.balance -= price;
    purse.spent += price;
    return true;
}

/// @function economy_reset(purse, starting)
/// @description Back to `starting`, totals cleared. A new run, not a new
/// save — persistent currency should outlive this.
function economy_reset(purse, starting) {
    purse.balance = starting;
    purse.earned = starting;
    purse.spent = 0;
}
