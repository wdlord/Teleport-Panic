/// @description teleport freeze

// pause
if (instance_exists(obj_player)) obj_player.frozen = true;
if (instance_exists(obj_other_player)) {
	obj_other_player.frozen = true;
}

// queue up alarm to actually teleport
alarm[3] = freeze_duration;

// host chooses new teleport locations for each player
if instance_exists(obj_server) {
	var player;
	var next_y;
	var next_x;
	
	// prep buffer
	with obj_client {
		buffer_seek(client_buffer, buffer_seek_start, 0);
		buffer_write(client_buffer, buffer_u8, network.teleport);
	}
	
	// choose and write all chosen player location to the buffer
	for (var i = 0; i < ds_list_size(obj_manager.player_list); i++) {
		
		// set new location for the player
		player = ds_list_find_value(obj_manager.player_list, i);
		
		if (!instance_exists(player)) break;
		
		// y-value is easy
		next_y = player.y + section_height;
		
		// x-value is harder
		if (player.x < section[0]) {
			next_x = section[s0_new] - (section[0] - player.x);
		}
		else if (player.x < section[1]) {
			next_x = section[s1_new] - (section[1] - player.x);
		}
		else if (player.x < section[2]) {
			next_x = section[s2_new] - (section[2] - player.x);
		}
		
		// write x and y coords to buffer
		with obj_client {
			buffer_write(client_buffer, buffer_u16, next_y);
			buffer_write(client_buffer, buffer_u16, next_x);
		}
	}
	//send all coords through server
	with obj_client {
		network_send_packet(client, client_buffer, buffer_tell(client_buffer));
	}
}

//shift room
alarm[4] = 0.5 * 60;	// how long to wait before camera pan