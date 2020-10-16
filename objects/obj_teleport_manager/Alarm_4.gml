/// @description camera pan

pan_view = true;

//get current pos and end position for pan
current_y = camera_get_view_y(view_camera[0]);
next_y = current_y + (9 * 64);
