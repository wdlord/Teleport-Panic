buffer = argument0;
socket = argument1;
//buffer_seek(buffer, buffer_seek_start, 0);
msgid = buffer_read(buffer,buffer_u8);
//show_message(msgid);

switch(msgid)
{
	case network.start: 
		
		//send size of ds list
		buffer_seek(server_buffer, buffer_seek_start, 0);
		buffer_write(server_buffer, buffer_u8, network.start);
		buffer_write(server_buffer, buffer_u8, ds_list_size(socket_list));
		var buffer_pos = buffer_tell(server_buffer);
		
		//tell my player to start game
		buffer_write(server_buffer, buffer_u8, 0);	//id is 0
		buffer_seek(server_buffer, buffer_seek_start, 0);
		received_packet_c(server_buffer);
		
		//send buffer and unique id to each socket (player)
		for (var i = 1; i < ds_list_size(socket_list); i++) {
			
			// we want to only send one id every time, so we overwrite it with this.
			buffer_seek(server_buffer, buffer_seek_start, buffer_pos);
			
			// write the id to the buffer
			var temp_socket = ds_list_find_value(socket_list, i);	// the socket we send to
			var your_id = i;										// which player is the client we're sending to
			buffer_write(server_buffer, buffer_u8, your_id);
			
			// send
			network_send_packet(temp_socket, server_buffer, buffer_tell(server_buffer));
		}
		
		//create confirmation table
		for (var i = 0; i < ds_list_size(socket_list); i++) {
			confirmation_table[i] = false;
		}
		
		break;
		
	//receiving movement data
	case network.movement:
		// make sure we are receiving all required inputs
		var buf_size = buffer_seek(buffer, buffer_seek_end, 1);
		buffer_seek(buffer, buffer_seek_start, 0);
		buffer_read(buffer,buffer_u8);
		
		if (buf_size == 6) {	// bandage patch for weird data
			// read data from buffer
			var temp_id = buffer_read(buffer, buffer_u8);
			var jump = buffer_read(buffer, buffer_bool);
			var left = buffer_read(buffer, buffer_bool);
			var right = buffer_read(buffer, buffer_bool);
			var shove = buffer_read(buffer, buffer_bool);
			var walk_dir = buffer_read(buffer, buffer_s8);
		
			// write data into movement_info structure
			var inputs = movement_info[| temp_id];
			inputs[0] = jump;
			inputs[1] = left;
			inputs[2] = right;
			inputs[3] = shove;
			inputs[4] = walk_dir;
			movement_info[| temp_id] = inputs;
		}
		
		break;
		
	//receiving new teleport mapping
	case network.teleport_sections:
	
		//get to end of buffer
		var offset = 1;
		while (buffer_peek(buffer, offset, buffer_u8) != undefined) {
			offset += 1;
		}
		
		//forward buffer
		for (var i = 0; i < ds_list_size(socket_list); i++) {
			var temp_socket = ds_list_find_value(socket_list, i);
			network_send_packet(temp_socket, buffer, offset);
		}
		
		break;
		
	// receiving new teleport positions
	case network.teleport:
		
		//get to end of buffer
		var offset = 1;
		while (buffer_peek(buffer, offset, buffer_u16) != undefined) {offset += 2;}
		
		//just forward buffer like before
		for (var i = 0; i < ds_list_size(socket_list); i++) {
			var temp_socket = ds_list_find_value(socket_list, i);
			network_send_packet(temp_socket, buffer, offset);
		}
		
		break;
		
	// receiving confirmation of room start
	case network.confirmation:
		
		// update confirmation table with confirmed player
		for (var i = 0; i < ds_list_size(socket_list); i++) {
			if socket == ds_list_find_value(socket_list, i) {
				confirmation_table[i] = true;
			}
		}
		
		// check to see if we can start
		var ready = false;
		for (var i = 0; i < ds_list_size(socket_list); i++) {
			if confirmation_table[i] == false {
				ready = false;
				break;
			}
			else {
				ready = true;
			}
		}
		
		// if we can start, send the command
		if ready {
			
			// prime buffer
			buffer_seek(server_buffer, buffer_seek_start, 0);
			buffer_write(server_buffer, buffer_u8, network.cell_map);
			
			//load up cell map
			for (var i = 0; i < map_levels; i++) {
				for (var j = 0; j < map_width; j++) {
					buffer_write(server_buffer, buffer_u8, obj_cell_manager.cell_map[i, j]);
				}
			}
			
			//send
			var buff_size = buffer_tell(server_buffer);
			for (var i = 0; i < ds_list_size(socket_list); i++) {
				var temp_socket = ds_list_find_value(socket_list, i);
				network_send_packet(temp_socket, server_buffer, buff_size);
			}
			
			//reset table
			confirmation_table = pointer_null;
		}
		
		break;
		
		// receiving notification of player death
		case network.death:
			var player_id = buffer_read(buffer, buffer_u8);
			
			buffer_seek(server_buffer, buffer_seek_start, 0);
			
			
			// check if there are any players remaining
			var players_remain = 0;
			for (var i = 0; i < ds_list_size(obj_manager.player_list); i++) {
				if (i != player_id) {
					if (instance_exists(ds_list_find_value(obj_manager.player_list, i))) {
						players_remain += 1;
					}
				}
			}
		
			// if there is one player left, end game
			if (players_remain <= 1) {
				buffer_write(server_buffer, buffer_u8, network.win);
				buffer_write(server_buffer, buffer_u8, player_id);
			}
			
			// if there are still players left tell clients to kill the one who died
			else {
				buffer_write(server_buffer, buffer_u8, network.death);
				buffer_write(server_buffer, buffer_u8, player_id);
			}
			//show_message(ds_list_find_value(socket_list, 0));
			//send
			var buff_size = buffer_tell(server_buffer);
			for (var i = 0; i < ds_list_size(socket_list); i++) {
				var temp_socket = ds_list_find_value(socket_list, i);
				network_send_packet(temp_socket, server_buffer, buff_size);
			}
			
			break;
			
		// when someone wins the game
		case network.win:
			
			var player_id = buffer_read(buffer, buffer_u8);
			
			buffer_seek(server_buffer, buffer_seek_start, 0);
			buffer_write(server_buffer, buffer_u8, network.win);
			buffer_write(server_buffer, buffer_u8, player_id);
			
			//send
			var buff_size = buffer_tell(server_buffer);
			for (var i = 0; i < ds_list_size(socket_list); i++) {
				var temp_socket = ds_list_find_value(socket_list, i);
				network_send_packet(temp_socket, server_buffer, buff_size);
			}
			
			break;
			
		// other players checking to see if host has not disconnected
		case network.ping:
			var buff_size = buffer_seek(buffer, buffer_seek_end, 0);
			network_send_packet(socket, buffer, buffer_tell(buffer));
			
			break;
			
		// if players clicks a button to leave the lobby
		case network.disconnect:
			
			network_destroy(socket);
			
			break;
}