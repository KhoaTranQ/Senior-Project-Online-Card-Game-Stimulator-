///net_rng(data)
/*
**  Description
**      Shows what partner rolled, including the lower and upper bounds.
*/

var data = argument0;

var min_ = buffer_read(data, buffer_f32);
var max_ = buffer_read(data, buffer_f32);
var rng = buffer_read(data, buffer_f32);

show_message_async("Opponent generated number between " + string(min_) + " and " + string(max_) + "#They recieved: " + string(rng) );
