/// @description generate cell

// WALLS
object_set_sprite(obj_wall, spr_wall);

var x_spawn;
var y_spawn = y + cell_height - 64;

// left side
x_spawn = x;
instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_lava_stone_left);

//right side
x_spawn = x + cell_width;
instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_lava_stone_right);

// lava

x_spawn = x + 64*3;
instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_lava);



