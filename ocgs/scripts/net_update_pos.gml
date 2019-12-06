///net_update_pos(data)
/*
**  Description
**      Updates the position of a card or deck.
**
**  Arguments
**      data    buffer      The buffer containing the data needed for the update.
**
**  Returns
**      <nothing>
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);

var xPos = buffer_read(data, buffer_f32);
var yPos = buffer_read(data, buffer_f32);

// Get the local instance associated with the given network ID.
var inst = syncMap[? net_id];

//inst.visible = true;

/*
if( !instance_exists(inst) )
{
    instance_activate_object(inst);
}
*/
with( inst )
{
    x = room_width - xPos;
    y = room_height - yPos;
    
    if(inst.object_index == obj_card)
    {
        scr_moveto_end(global.freeCards, id);
        scr_update_depths();
    }
    
}
