/// @description show players the mapping

// create indicators for current row
var y_spawn = ((6 - times) * cell_height) + cell_height;	//spawns at top of current level

object_set_sprite(obj_indicator, spr_s0);
var indicator = instance_create_layer(section[0], y_spawn, "Section_UI", obj_indicator);

object_set_sprite(obj_indicator, spr_s1);
indicator = instance_create_layer(section[1], y_spawn, "Section_UI", obj_indicator);

object_set_sprite(obj_indicator, spr_s2);
indicator = instance_create_layer(section[2], y_spawn, "Section_UI", obj_indicator);

// create indicators for next row
y_spawn += cell_height;		//spawns at top of next level

object_set_sprite(obj_indicator, spr_s0);
indicator = instance_create_layer(section[s0_new], y_spawn, "Section_UI", obj_indicator);

object_set_sprite(obj_indicator, spr_s1);
indicator = instance_create_layer(section[s1_new], y_spawn, "Section_UI", obj_indicator);

object_set_sprite(obj_indicator, spr_s2);
indicator = instance_create_layer(section[s2_new], y_spawn, "Section_UI", obj_indicator);
