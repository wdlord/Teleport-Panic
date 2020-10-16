var cell = argument0;
var i = argument1;
var j = argument2;

switch (cell) {
	
	case cells.basic:
		instance_create_layer(cell_width*j, cell_height*i, "Instances", obj_basic_cell);
		break;
		
	case cells.center_lava:
		instance_create_layer(cell_width*j, cell_height*i, "Instances", obj_center_lava);
		break;
		
	case cells.tomb:
		instance_create_layer(cell_width*j, cell_height*i, "Instances", obj_tomb);
		break;
		
	case cells.mansion:
		instance_create_layer(cell_width*j, cell_height*i, "Instances", obj_mansion);
		break;
		
	case cells.jungle:
		instance_create_layer(cell_width*j, cell_height*i, "Instances", obj_jungle);
		break;
}