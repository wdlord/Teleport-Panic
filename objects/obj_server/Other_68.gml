type_event = ds_map_find_value(async_load, "type");

switch(type_event)
{
	case network_type_connect:
		
		socket = ds_map_find_value(async_load, "socket");
		ds_list_add(socket_list, socket);
		
		break;
		
	case network_type_disconnect:
	
		socket = ds_map_find_value(async_load, "socket");
		ds_list_delete(socket_list, ds_list_find_index(socket_list,socket));
		
		break;
		
	case network_type_data:
		
		buffer = ds_map_find_value(async_load, "buffer");
		socket = ds_map_find_value(async_load, "id");
		
		// the "if" forbids server from sending itself information, some sockets are garbage idk why
		if (socket > ds_list_find_value(socket_list, 0)-1) {
			buffer_seek(buffer, buffer_seek_start,0);
			received_packet_s(buffer, socket);
		}
		break;
}