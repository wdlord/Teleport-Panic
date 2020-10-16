/// @description Insert description here

// starting game
if (room == teleport_panic) {
	spawn_players(size, temp_id);
}

// victory screen
if (room == rm_win) {
	show_message("player " + string(victor) + " wins!");
}

// returning to main menu
if (room == rm_menu) {
	
}
