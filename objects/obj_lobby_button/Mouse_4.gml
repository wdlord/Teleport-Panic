/// @description send players back to lobby

with (obj_manager) ds_list_destroy(player_list);

room_goto(rm_menu);
