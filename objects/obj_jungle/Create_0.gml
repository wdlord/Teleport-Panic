/// @description Insert description here

// 1 thick floor of mud
var x_spawn = x;
var y_spawn = y + cell_height - 64;

instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_mud);
