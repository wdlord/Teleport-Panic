
// client socket -> server
client = network_create_socket(network_socket_tcp);
network_set_config(network_config_connect_timeout, 4000); // try to connect for 4 seconds
connected = network_connect(client, obj_manager.connected_ip_address, 64198);

// if connection failed
if (connected < 0) {
	show_message("Couldn't connect to server.");
	obj_join_button.connection_succeeded = false;
	instance_destroy();
}
else obj_join_button.connection_succeeded = true;

//show_message(connected);
client_buffer = buffer_create(1024,buffer_fixed,1);

persistent = true; // stays when room changes