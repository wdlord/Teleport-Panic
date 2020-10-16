/// @description camera pan

if  (pan_view = true) {
	
	//pan the camera
	if (current_y < next_y) {
		
		//get as close as possible to next_y
		if (y + pan_speed < next_y) {
			
			pan_speed += pan_accel;
			y += pan_speed;
			
			//update camera location
			camera_set_view_pos(view_camera[0], x, y);
			current_y = camera_get_view_y(view_camera[0]);
		}
		
		//then set pos to next_y
		else {
			y = next_y;
			
			//update camera location
			camera_set_view_pos(view_camera[0], x, y);
			current_y = camera_get_view_y(view_camera[0]);
			
		}
	}
	
	//reset variables once pan has completed
	else {
		pan_speed = 0;
		pan_view = false;
	}
}