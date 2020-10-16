/// @description pinging server

// quit if host disconnected
if (!ping_received) {
	show_message("host disconnected");
	connected_ip_address = "";
	room_goto(rm_server_stuff);
}

//otherwise ping again
else {
	ping_received = false;
	alarm[0] = ping_frequency; 
	
	with (obj_client) {
		buffer_seek(client_buffer, buffer_seek_start, 0);
		buffer_write(client_buffer, buffer_u8, network.ping);
		network_send_packet(client, client_buffer, buffer_tell(client_buffer));
	}
}