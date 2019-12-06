///net_deck_remove(data)
/*
**  Description
**      Removes an entry from a deck
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var index = buffer_read(data, buffer_f32);

var local_ = syncMap[? net_id];

ds_list_delete(local_.list, index);
