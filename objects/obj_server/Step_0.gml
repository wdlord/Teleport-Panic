/// @description Send packets on server tick

if (room != rm_server_stuff && room != rm_menu) {
	buffer_seek(server_buffer, buffer_seek_start, 0);
	buffer_write(server_buffer, buffer_u8, network.movement);

	var player_count = ds_list_size(obj_manager.player_list);
	
	//for every player in our list
	for (var i = 0; i < player_count; i++) {
	
		//this is the array containing movement data
		var inputs = movement_info[| i];
		
		if (array_length_1d(inputs) < 5) inputs[4] = 0; // bandage
		
		//for each input in the array
		for (var j = 0; j < 4; j++) {
			buffer_write(server_buffer, buffer_bool, inputs[j]);
		}
		// don't forget walk_dir
		buffer_write(server_buffer, buffer_s8, inputs[4]);
	}

	//avoid repeatedly calling in for loop
	var buff_size = buffer_tell(server_buffer);
		
	//send movement data of players over the network
	for (var i = 0; i < ds_list_size(socket_list); i++) {
		var temp_socket = ds_list_find_value(socket_list, i);
		network_send_packet(temp_socket, server_buffer, buff_size);
	}
}