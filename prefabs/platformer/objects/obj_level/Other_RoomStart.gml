// Counted here rather than in Create: Create runs as each instance is made,
// so a controller placed first in the layer would count a half-built room.
global.coins_total = instance_number(obj_coin);
