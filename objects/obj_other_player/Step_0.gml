/// @description Insert description here
// You can write your code in this editor

if (!frozen) {
		//JUMP PHYSICS
	//-----------------

	//if they press jump
	if jump {
	
		//set base jump speed if on the ground and jump key is pressed
		if (place_meeting(x, y+1, obj_wall) && !place_meeting(x, y-1, obj_wall)) {
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
	else if (!place_meeting(x, y+1, obj_wall)) {
		while (!place_meeting(x, y+1, obj_wall)) {
			y+= 1;
		}
	}



	//LEFT/RIGHT MOVEMENT
	//----------------------

	//if either directional key is pressed
	if left || right {
	
		//movement physics---
	
		//set move speed
		horizontal_speed = walk_direction * walk_speed;
		
		// move slower on mud
		if (place_meeting(x, y+1, obj_mud)) {
			horizontal_speed = walk_direction * (walk_speed/2);	
		}
		
		//if we won't run into anything
		about_to_collide = place_meeting(x+horizontal_speed, y, obj_wall);
		if (!about_to_collide) {x += horizontal_speed;}
		
		else {
			while (!place_meeting(x+(walk_direction*1), y, obj_wall)) {
				x += walk_direction*1;
			}
		}
	}

	//maintain air speed if key is not pressed
	else if (!place_meeting(x, y+1, obj_wall) && x!= last_x) {
		x += horizontal_speed;
	}

	// so we know whether or not to move in the air
	last_x = x;
	
	//shove
	if (shove) {
		
		// check if we hit anyone, tell them they were shoved
			if (place_meeting(x, y, obj_other_player)) {
				
				var player = instance_place(x, y, obj_other_player);
				
				//I don't want the shadow to have any collision
				if (player != obj_player.shadow) {
					player.shove_dir = sign(player.x - x);
					player.shoved = true;
				}
			}
			
			//allows simulating player shove without false player shoving real player
			if (place_meeting(x, y, obj_player) && (obj_player.shadow != id)) {
				
				var player = instance_place(x, y, obj_player);
				player.shove_dir = sign(player.x - x);
				player.shoved = true;
			}
	}
	
	//shoved
	if (shoved) {
		//calculate altered x values
		shove_dist = (shove_sp - shove_change);
		if (shove_dist > 0) {
			// +/- speed at a decreasing value
			shove_change += shove_fr; 
			
			// normal shove
			if (!place_meeting(x + (shove_dir*shove_dist), y, obj_wall)) {
				x += shove_dir * shove_dist;
			}
			else { // meet wall if necessary
				while (!place_meeting(x+shove_dir, y, obj_wall)) {
					x += shove_dir;
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

