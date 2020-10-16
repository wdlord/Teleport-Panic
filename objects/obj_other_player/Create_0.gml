/// @description Initialization of other players

//movement variables
vertical_speed =  0;		// current speed of player's jump/fall
horizontal_speed =  0;		// current speed of the player's horizontal movement (negative is left)
last_x = -60;				// this value gets checked against x to see if we are moving in air

frozen = false;

//getting pushed variables
shoved = false;
shove_dir =  0;				// depends on positional relationship between shover and shovee
shove_change = 0;			// shrinks exponentially (affected by friction)

//booleans - these indicate if the other person is pressing their movement keys
jump = false;
left = false;
right = false;
shove = false;

walk_direction = 0;