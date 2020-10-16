/// @description Insert description here

// this info gets sent to the server at the bottom
jump_p = keyboard_check(jump_key);
left_p = keyboard_check(left_key);
right_p = keyboard_check(right_key);
shove_p = keyboard_check(shove_key);


// necessary for clean L/R movement
if (keyboard_check_pressed(left_key)) {
	walk_dir_p = -1;
}
if (keyboard_check_pressed(right_key)) {
	walk_dir_p = 1;
}
if (keyboard_check_released(left_key) && keyboard_check(right_key)) {
	walk_dir_p = 1;
}
if (keyboard_check_released(right_key) && keyboard_check(left_key)) {
	walk_dir_p = -1;
}

// false player shares player frozen status
if instance_exists(obj_false_player) obj_false_player.frozen = frozen;

if (!frozen) {
		//JUMP PHYSICS
	//-----------------

	//if they press jump
	if jump {
	
		//set base jump speed if on the ground and jump key is pressed
		if (on_ground && !place_meeting(x, y-1, obj_wall)) {
			vertical_speed = jump_speed;
			y -= vertical_speed;
		}
	}

	//increase falling speed if in the air
	if (!place_meeting(x, y-(vertical_speed - grv), obj_wall)) {
		vertical_speed -= grv;
	   y -= vertical_speed;
	}
	//land perfectly flush with surface
	else if (!on_ground) {
		while (!on_ground) {
			y += 1;
		}
	}



	//LEFT/RIGHT MOVEMENT
	//----------------------

	//if either directional key is pressed
	if left || right {
		
		//movement physics---
	
		//setting horizontal speed
		horizontal_speed = walk_direction * walk_speed;
		
		// move slower on mud
		if (place_meeting(x, y+1, obj_mud)) {
			horizontal_speed = walk_direction * (walk_speed/2);	
		}
	
		//if we won't run into anything
		about_to_collide = place_meeting(x+horizontal_speed, y, obj_wall);
		if (!about_to_collide) x += horizontal_speed;
		
		//if we are about to run into something move right up to that object.
		else {
			while (!place_meeting(x+walk_direction, y, obj_wall)) {
				x += walk_direction;
			}
		}
	}

	//maintain air speed if left or right key is not pressed
	else if (!on_ground && x != last_x) {
		x += horizontal_speed;
	}

	// so we know whether or not to move in the air
	last_x = x;
	
	// if server says we've pressed shove key...
	if (shove) {
		
		// check if we hit anyone, tell them they were shoved
		if (place_meeting(x, y, obj_other_player)) {
				
			var player = instance_place(x, y, obj_other_player);
			with (player) {
				if (object_index != obj_false_player) {
					shove_dir = sign(x - obj_player.x);
					shoved = true;
				}
			}
			//if (player != shadow) {
			//	player.shove_dir = sign(player.x - x);
			//	player.shoved = true;
			//}
		}
	}
	
	//if we've been shoved by another player
	if (shoved) {
		
		//calculate altered x values
		shove_dist = (shove_sp - shove_change);
		if (shove_dist > 0) {
			// +/- speed at a decreasing value
			shove_change += shove_fr; 
			
			// normal shove
			if (!place_meeting(x + (shove_dir*shove_dist), y, obj_wall)) {
				x += shove_dir * shove_dist;
				if (instance_exists(obj_false_player)) {
					obj_false_player.x += shove_dir * shove_dist;
				}
			}
			else { // meet wall if necessary
				while (!place_meeting(x+shove_dir, y, obj_wall)) {
					x += shove_dir;
				}
				if (instance_exists(obj_false_player)) {
					while (!place_meeting(obj_false_player.x+shove_dir, y, obj_wall)) {
					obj_false_player.x += shove_dir;
				}
				}
			}
		}
		// stop changing the x values
		else {
			shoved = false;
			shove_change = 0;
		}
	}
}

// fixes directional problem caused by freezing
else {
		if left {walk_direction = -1;}
		if right {walk_direction = 1;}
}

// ensures player on server is as close as possible to player on client
if instance_exists(obj_false_player) {
	if (abs(x - obj_false_player.x)) > 5 { 
		obj_false_player.x = x;
	}
}

//NETWORKING
if (step_count % frame_div = 0) {
	step_count = 1;
	
	//send movement data to server
	with (obj_client) {
		buffer_seek(client_buffer, buffer_seek_start, 0);
		buffer_write(client_buffer, buffer_u8, network.movement);
		buffer_write(client_buffer, buffer_u8, obj_manager.my_id);
		buffer_write(client_buffer, buffer_bool, obj_player.jump_p);
		buffer_write(client_buffer, buffer_bool, obj_player.left_p);
		buffer_write(client_buffer, buffer_bool, obj_player.right_p);
		buffer_write(client_buffer, buffer_bool, obj_player.shove_p);
		buffer_write(client_buffer, buffer_s8, obj_player.walk_dir_p);
		network_send_packet(client, client_buffer, buffer_tell(client_buffer));
	}
	
	//send inputs to false_player
	if instance_exists(obj_false_player) {
		obj_false_player.jump = jump_p;
		obj_false_player.left = left_p;
		obj_false_player.right = right_p;
		obj_false_player.shove = shove_p;
		obj_false_player.walk_direction = walk_dir_p;
	}
}
else {step_count += 1;}