/// @description win condition

with (obj_client) { // send id to server
	buffer_seek(client_buffer, buffer_seek_start, 0);
	buffer_write(client_buffer, buffer_u8, network.win);
	buffer_write(client_buffer, buffer_u8, obj_player.player_id);
	network_send_packet(client, client_buffer, buffer_tell(client_buffer));
}
