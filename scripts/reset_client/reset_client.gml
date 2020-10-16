with (obj_manager) {
	client = instance_create_layer(0, 0, "Instances", obj_client);
	my_id = pointer_null;
	
	// for spawning players
	size = -1;
	temp_id = -1;
	my_player = pointer_null;
	player_list = ds_list_create();
	
	// for winning game
	victor = pointer_null;
	
	// for ensuring host is connected
	ping_received = true;
	ping_frequency = 2*60; // roughly 2 seconds	
}