/// @function economy_price(base, level, growth)
/// @description What the next one costs when each purchase makes the next
/// dearer: `base * growth^level`, rounded. `growth` of 1.15 is the usual
/// shape — steep enough to matter by level ten, gentle enough at level two.
function economy_price(base, level, growth) {
    return round(base * power(growth, level));
}

/// @function economy_afford_count(purse, base, level, growth)
/// @description How many more could be bought right now at a growing price,
/// spending nothing. What a "buy max" button needs.
function economy_afford_count(purse, base, level, growth) {
    var _funds = purse.balance;
    var _n = 0;
    while (true) {
        var _cost = economy_price(base, level + _n, growth);
        if (_cost > _funds || _cost <= 0) break;
        _funds -= _cost;
        _n += 1;
    }
    return _n;
}

/// @function economy_format(amount)
/// @description Thousands separated — 1234567 becomes "1,234,567". A raw
/// seven-digit number is unreadable at a glance, which is the only moment a
/// player ever looks at it.
function economy_format(amount) {
    var _neg = amount < 0;
    var _digits = string(abs(round(amount)));
    var _out = "";
    var _n = string_length(_digits);
    for (var i = 1; i <= _n; i++) {
        _out += string_char_at(_digits, i);
        var _left = _n - i;
        if (_left > 0 && _left mod 3 == 0) _out += ",";
    }
    return (_neg ? "-" : "") + _out;
}

