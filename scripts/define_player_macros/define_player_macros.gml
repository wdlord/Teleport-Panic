
// constant variables needed for shoving mechanics
#macro shove_sp 6						// initial shove strength
#macro shove_fr 0.2						// friction from the shove (effect grows exponentially)

// constant variables used in player movement
#macro jump_speed 10					// initial jump strength
#macro grv 0.8							// strength of gravity acting on player (effect grows exponentially)
#macro walk_speed 3.5					// how fast players move side to side (ground)
#macro air_resistance 0.5				// speed of the player when moving side to side in the air

// used to improve readability of code
#macro on_ground place_meeting(x, y+1, obj_wall)