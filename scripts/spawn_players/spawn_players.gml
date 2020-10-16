
var size = argument0;
var temp_id = argument1;

with (obj_manager) {
			player_list = ds_list_create();
			my_id = temp_id;
			var x_offset = 200;
			
			//create false_player object
			var fp = instance_create_layer(200, 0, "Players", obj_false_player);
			
			//correct info for this will be set further down
			my_player = instance_create_layer(200, 0, "Players", obj_player);
			
			//fill player list, create objects, and give them id's
			for (var i = 0; i < size; i++) {
				
				//make server create movement structure
				if (instance_exists(obj_server)) {
					inputs = array_create(5);
					obj_server.movement_info[| i] = inputs;
				}
				
				//if not this player, create other_player object
				if (i != my_id) {
					var player = instance_create_layer(200+(i*x_offset), 0, "Players", obj_other_player);
					ds_list_add(player_list, player);
					player.player_id = i;
				}
				
				// if it is this player, add the player to the list
				else {
					ds_list_add(player_list, my_player);
					my_player.player_id = i;
					my_player.x = 200+(i*x_offset);
					
					//false player location correction
					fp.x = my_player.x;
					fp.y = my_player.y
					my_player.shadow = fp;
				}
			}
}