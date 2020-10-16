/// @description Initialization

// 1 thick floor
var x_spawn;
var y_spawn = y + cell_height - 64;

x_spawn = x;
instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_tile);


// HAZARDS

// statue
y_spawn -= 1;
x_spawn = x + 64 * 2;
instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_statue);