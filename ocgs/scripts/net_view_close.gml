///net_view_close(data)

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var local_ = syncMap[? net_id];

local_.image_blend = c_white;
