///net_hand_insert(data)
/*
**  Description
**      Registers that a specific card is in the opponents hand.
**
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var last_zone = buffer_read(data, buffer_u8);
//var local_ = syncMap[? net_id];
if( last_zone != zone.hand)
{
    with(global.input_object) scr_deselect_multi();
    hand_size++;
    with(syncMap[? net_id])
    {
        instance_destroy();
    }
    
    ds_map_delete(syncMap, net_id);
}

//"mark" the card as being in the hand, and otherwise not existing.
//syncMap[? net_id] = "hand";

/*
var local_inst = syncMap[? net_id];

local_inst.visible = false;

if(local_inst.flipped == true)
{
    local_inst.flipped = false;
    local_inst.image_index = 0;
}
*/
//instance_deactivate_object(local_inst);

/*ds_map_delete(syncMap, net_id);

with( local_inst )
{
    debug(object_get_name(local_inst.object_index));
    instance_destroy();
}
