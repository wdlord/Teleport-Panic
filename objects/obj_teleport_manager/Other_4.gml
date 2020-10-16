/// @description Initialization
if (room == teleport_panic) {
	y = 64; //prefer setting in here vs in networking script
	camera_set_view_pos(view_camera[0], x, y);

	times = 6;	// how many times we teleport

	// define size and location of sections
	section_width = room_width/3;
	section_height = 8 * 64;

	section[0] = 0 + section_width * 1;
	section[1] = 0 + section_width * 2;
	section[2] = 0 + section_width * 3;

	// map sections
		s0_new = -1;
		s1_new = -1;
		s2_new = -1;

	// first freeze timer
	teleport_speed = 5 * 60;
	freeze_duration = 2 * 60;

	// teleport cycle
	alarm[0] = 60;

	// camera controls
	pan_view = false;
	pan_accel = 1;
	pan_speed = 0;


	// location table contains the mapping of the sections and is sent over server
	location_table = ds_list_create();

	// fill location table with arrays
	for (var i = 0; i < ds_list_size(obj_manager.player_list); i++) {
		var coords = array_create(2);
		location_table[| i] = coords;
	}
}