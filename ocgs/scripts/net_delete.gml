///net_delete(data)
/*
**  Description
**      Deletes a specified card, and acounts for if it was in the hand or not
**
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var in_hand = buffer_read(data, buffer_bool);

var local_inst = syncMap[? net_id];

with(global.input_object)
{
    if local_inst == selected
        selected = noone;
    scr_deselect_multi();
}

ds_map_delete(syncMap, net_id);

with( local_inst )
{
    instance_destroy();
}

if(in_hand)
{
    hand_size--;
}
