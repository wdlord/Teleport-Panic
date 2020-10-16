/// @description destroys shadow
instance_destroy(obj_false_player);

// network this player's death
with (obj_client) {
	//show_message("hey");
	buffer_seek(client_buffer, buffer_seek_start, 0);
	buffer_write(client_buffer, buffer_u8, network.death);
	buffer_write(client_buffer, buffer_u8, obj_player.player_id);
	network_send_packet(client, client_buffer, buffer_tell(client_buffer));
}
