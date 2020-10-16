buffer = argument0;
msgid = buffer_read(buffer,buffer_u8);

switch(msgid)
{
	
	//game has been started
	case network.start:
		
		// make sure we are receiving all required inputs
		var buf_size = buffer_seek(buffer, buffer_seek_end, 1);
		buffer_seek(buffer, buffer_seek_start, 0);
		buffer_read(buffer,buffer_u8);
		
		if (buf_size != 0) {	// bandage patch for weird data
			
			//get socket_list size
			var size = buffer_read(buffer, buffer_u8);
			var temp_id = buffer_read(buffer, buffer_u8);
		
			//give manager the information needed to spawn the players
			obj_manager.size = size;
			obj_manager.temp_id = temp_id;
			with (obj_manager) alarm[0] = ping_frequency; // start pinging server
		
			//go to first room
			room_goto(teleport_panic);
			instance_create_layer(0, 0, "Instances", obj_cell_manager);
			instance_create_layer(0, 0, "Instances", obj_teleport_manager);
		
			//send server confirmation
			with obj_client {
				buffer_seek(client_buffer, buffer_seek_start, 0);
				buffer_write(client_buffer, buffer_u8, network.confirmation);
				network_send_packet(client, client_buffer, buffer_tell(client_buffer));
			}
		}
		
		break;
		
	// player movement data recieved
	case network.movement:
		
		// make sure we are receiving all required inputs
		var buf_size = buffer_seek(buffer, buffer_seek_end, 1);
		buffer_seek(buffer, buffer_seek_start, 0);
		buffer_read(buffer,buffer_u8);
		
		var num_players = ds_list_size(obj_manager.player_list);
		
		if (buf_size == 5*num_players) { // bandage fix for things i cant track down
			
			//iterates over the player list
			for (var i = 0; i < num_players; i++) {
				
				var player = ds_list_find_value(obj_manager.player_list, i);
				if instance_exists(player) {
					
					if (buffer_peek(buffer, i, buffer_bool) != undefined){	//sloppy bandage, idk what's wrong
						
						player.jump = buffer_read(buffer, buffer_bool);
						player.left = buffer_read(buffer, buffer_bool);
						player.right = buffer_read(buffer, buffer_bool);
						player.shove = buffer_read(buffer, buffer_bool);
						player.walk_direction = buffer_read(buffer, buffer_s8);
					}
				}
			}
		}
		
		break;
	
	// receiving new teleport mapping
	case network.teleport_sections:
		
		if (instance_exists(obj_teleport_manager)) {
			obj_teleport_manager.s0_new = buffer_read(buffer, buffer_u8);
			obj_teleport_manager.s1_new = buffer_read(buffer, buffer_u8);
			obj_teleport_manager.s2_new = buffer_read(buffer, buffer_u8);
		}
		
		break;
	
	// receiving new teleport positions
	case network.teleport:
		
		//update ds_list structure of player next coords
		for (var i = 0; i < ds_list_size(obj_manager.player_list); i++) {
			if (instance_exists(ds_list_find_value(obj_manager.player_list, i))) {
				var coords = obj_teleport_manager.location_table[| i];
				coords[0] = buffer_read(buffer, buffer_u16);
				coords[1] = buffer_read(buffer, buffer_u16);
				obj_teleport_manager.location_table[| i] = coords;
			}
		}
		
		break;
		
	// receiving cell map
	case network.cell_map:
		
		// populate the cell map with the data
		for (var i = 0; i < map_levels; i++) {
			for (var j = 0; j < map_width; j++) {
				var cell = buffer_read(buffer, buffer_u8);
				populate_cell_map(cell, i, j);
			}
		}
		// create win condition
		var y_spawn = (map_levels * cell_height) - 64;
		var x_spawn = cell_width * 1.5 - 64;
		instance_create_layer(x_spawn, y_spawn, "Cell_Walls", obj_victory);
		
		break;
		
	// delete the player that died
	case network.death:
		var player_id = buffer_read(buffer, buffer_u8);
		var player = ds_list_find_value(obj_manager.player_list, player_id);
		if (instance_exists(player)) instance_destroy(player);
		
		break;
		
	// when the server chose the winner
	case network.win:
		//show_message(socket);
		var player_id = buffer_read(buffer, buffer_u8);
		
		// tell manager who won
		with (obj_manager) {
			victor = player_id;
		}
		instance_destroy(obj_teleport_manager);
		instance_destroy(obj_cell_manager);
		room_goto(rm_win);
		
		break;
		
	// receiving confirmation host is still connected
	case network.ping:
		
		obj_manager.ping_received = true;
		
		break;
}