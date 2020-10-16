/// @description creates the initial client

depth = -500;
my_id = pointer_null;
tick_rate = 3;

// for spawning players
size = -1;
temp_id = -1;
my_player = pointer_null;

// for winning game
victor = pointer_null;

randomize();

// for ensuring host is connected
ping_received = true;
ping_frequency = 2*60; // roughly 2 seconds

// empty string used because of the way we obtain the ip
connected_ip_address = "";