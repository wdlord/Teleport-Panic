/// @description Walls

object_set_sprite(obj_wall, spr_desert_wall);

var x_spawn = x;
var y_spawn = y;

instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_tomb_walls);