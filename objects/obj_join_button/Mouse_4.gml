/// @description join a server

obj_manager.connected_ip_address = get_string("Enter IP Adress: ", "127.0.0.1");

// avoids crashing when the player hits cancel
if (obj_manager.connected_ip_address != "") {
	reset_client();
	if connection_succeeded room_goto(rm_menu);
}