/// @description start game if host

// only the host can start the game
if (instance_exists(obj_server)) {
	
	with (obj_client) {
		buffer_seek(client_buffer, buffer_seek_start, 0);
		buffer_write(client_buffer, buffer_u8, network.start);
		network_send_packet(client, client_buffer, buffer_tell(client_buffer));
	}
}
