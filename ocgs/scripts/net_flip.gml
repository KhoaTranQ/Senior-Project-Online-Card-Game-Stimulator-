///net_flip(data)
/*
**  Description
**      Flips a card based on information from partner
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);

var local_inst = syncMap[? net_id];

type = noone;
if(local_inst.object_index != noone)
    type = local_inst.object_index;
    
if(type = obj_card)
    scr_flip_card(local_inst);
else if(type = obj_deck)
    scr_flip_deck(local_inst);
