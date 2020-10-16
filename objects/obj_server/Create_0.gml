enum network
{
	start,
	movement,
	teleport_sections,
	teleport,
	cell_map,
	confirmation,
	death,
	win,
	ping,
	disconnect,
}

port = 64198;
max_clients = 8;

// server = 0
server = network_create_server(network_socket_tcp, port, max_clients);
 
server_buffer = buffer_create(1024, buffer_fixed, 1);
socket_list = ds_list_create();
tick_rate = 6; //every 6 frames, aka every 1/10 second

// for movement
movement_info = ds_list_create();

persistent = true;
