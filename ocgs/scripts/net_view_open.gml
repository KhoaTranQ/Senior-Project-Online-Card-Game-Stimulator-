///net_view_open(data)

var data = argument0;

var net_id = buffer_read(data, buffer_string)
var num = buffer_read(data, buffer_f32);
var local_ = syncMap[? net_id];

local_.image_blend = c_red;

net_log_add("Other player viewing " + string(num) + " out of " + string(ds_list_size(local_.list)) + " cards in a deck.");
