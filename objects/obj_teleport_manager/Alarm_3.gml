/// @description teleport execution

//teleport
for (var i = 0; i < ds_list_size(location_table); i++) {
	var player = ds_list_find_value(obj_manager.player_list, i);
	var coords = location_table[| i];
	
	if (!instance_exists(player)) break;
	
	//set the give player's new location
	player.y = coords[0];
	player.x = coords[1];
	
	//if that player is us, set the false player's new location as well
	if (i = obj_manager.my_id) {
		obj_false_player.x = player.x;
		obj_false_player.y = player.y;
	}
	
	//TELEPORT FATALITIES
	
	// check for collision with sword statue
	with (player) {
		if (place_meeting(x, y, obj_statue)) {
			instance_create_layer(x, y, "Players", obj_player_skewered);
			instance_destroy();
		}
	}
	
	// check for stuck in wall
	with (player) {
		if (place_meeting(x, y, obj_wall)) {
			instance_create_layer(x, y, "Players", obj_player_in_wall);
			instance_destroy();
		}
	}
}

//un-freeze
if (instance_exists(obj_player)) obj_player.frozen = false;
if (instance_exists(obj_other_player)) obj_other_player.frozen = false;

//set teleport timer again
if (times > 1) {
	teleport_cycle();
	times -= 1;
}