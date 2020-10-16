/// @description destroy lists

for (var i = 0; i < ds_list_size(socket_list); i++) {
	network_destroy(ds_list_find_value(socket_list, i));
}
ds_list_destroy(socket_list);
ds_list_destroy(movement_info);