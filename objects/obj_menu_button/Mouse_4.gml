/// @description send player back to menu

// notify server that this client is disconnecting
with (obj_client) {
	buffer_seek(client_buffer, buffer_seek_start, 0);
	buffer_write(client_buffer, buffer_u8, network.disconnect);
	network_send_packet(client, client_buffer, buffer_tell(client_buffer));
}

// reset
if (instance_exists(obj_client)) instance_destroy(obj_client);
if (instance_exists(obj_server)) instance_destroy(obj_server);
with (obj_manager) ds_list_destroy(player_list);
obj_manager.connected_ip_address = "";

room_goto(rm_server_stuff);
