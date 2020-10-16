
// pick teleport mapping (if host)
if (instance_exists(obj_server)) {
	
	// map sections
	var s0_new = -1;
	var s1_new = -1;
	var s2_new = -1;

	s0_new = irandom_range(0, 2);

	s1_new = irandom_range(0, 2);
	while (s1_new == s0_new) {
		s1_new = irandom_range(0, 2);
	}

	s2_new = irandom_range(0, 2);
	while (s2_new == s0_new || s2_new == s1_new) {
		s2_new = irandom_range(0, 2);
	}
	
	// prime buffer
	with obj_client {
		buffer_seek(client_buffer, buffer_seek_start, 0);
		buffer_write(client_buffer, buffer_u8, network.teleport_sections);
		buffer_write(client_buffer, buffer_u8, s0_new);
		buffer_write(client_buffer, buffer_u8, s1_new);
		buffer_write(client_buffer, buffer_u8, s2_new);
		network_send_packet(client, client_buffer, buffer_tell(client_buffer));
	}
}

// alarm to show players the mapping
alarm[1] = 2 * 60;	// 2 seconds

// alarm for teleport freeze
alarm[2] = teleport_speed;