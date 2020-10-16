/// @description generate cell

// WALLS
object_set_sprite(obj_wall, spr_wall);

var x_spawn;
var y_spawn = y + cell_height - 64;

// 1 thick floor
x_spawn = x;
instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_grass);

