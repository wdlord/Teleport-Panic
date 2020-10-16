/// @description host the server

instance_create_layer(0, 0, "Instances", obj_server);
obj_manager.connected_ip_address = "127.0.0.1";
reset_client();
room_goto(rm_menu);
