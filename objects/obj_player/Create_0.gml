/// @description Initialization

//define keyboard inputs
jump_key = ord("W");
left_key = ord("A");
right_key  = ord("D");
shove_key = vk_space;




//movement variables
vertical_speed = 0;			// current speed of player's jump/fall
horizontal_speed = 0;		// current speed of the player's horizontal movement (negative is left)
last_x = -60;				// this value gets checked against x to see if we are moving in air


//needed for Teleport Panic
frozen = false;

//getting pushed variables
shoved = false;
shove_dir = 0;			// depends on position of shover
shove_change = 0;		// changes throughout the duration (based on friction)

//networking
step_count = 0;
frame_div = obj_manager.tick_rate;
my_id = obj_manager.client.client;
player_id = -1;

jump = false;
left = false;
right = false;
shove = false;
walk_direction = 0;
walk_dir_p = 0;

shadow = -1;	//the obj id of the false player