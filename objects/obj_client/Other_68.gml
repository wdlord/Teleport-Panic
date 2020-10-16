type_event = ds_map_find_value(async_load,"type");

switch(type_event)
{
	case network_type_data:
		
		socket = ds_map_find_value(async_load, "id");
		//show_message(socket);
		buffer = ds_map_find_value(async_load,"buffer");
		buffer_seek(buffer,buffer_seek_start,0);
		received_packet_c(buffer);
		
		break;
}