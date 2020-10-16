/// @description generate the cell map
if (room == teleport_panic) {
	//enum representing the cells avaialable
	enum cells {
		basic,
		center_lava,
		tomb,
		mansion,
		jungle,
		size,		//this makes adding new cells when coding easier
	}

	// host generates the map
	if instance_exists(obj_server) {
	
		// FIRST ROW
		// --------------------
		for (var j = 0; j < map_width; j++) {
			cell_map[0, j] = cells.basic;
		}
	
		unusable[3] = -1;	// will be a 4 element array, [0]-[2] are cells used this level
							//	[3] is sometimes tomb cell so can't spawn consecutive levels
		last_tomb = -1;		// determines wether or not we can reset unusable[3]
	
		// NORMAL GAME ROWS
		// -------------------
		for (var i = 1; i < map_levels; i++) {	// per map level
		
			// clear unusable[] NOT COUNTING last element to track tombs
			for (var k = 0; k < 3; k++) unusable[k] = -1;
		
			for (var j = 0; j < map_width; j++) {	// per cell
			
				do {	// generate cell
					cell_map[i, j] = irandom(cells.size-1);
					acceptable_cell = true;
				
					// check if it is disallowed list
					for (var k = 0; k < 4; k++) {
						if (cell_map[i, j] == unusable[k]) {
							acceptable_cell = false;
							break;
						}
					}
				}
				until acceptable_cell;
			
				// can't use same cell twice on same level
				unusable[j] = cell_map[i, j];
			
				// note that this level has a tomb if necessary
				if (cell_map[i, j] == cells.tomb) {
					unusable[3] = cells.tomb;
					last_tomb = i;
				}
			}
			// note that next level can have a tomb
			if (last_tomb < i-1) unusable[3] = -1;
		}
	}
}
