///net_update_deckPos(data)
/*
**  Description
**      Updates local deck's position to match partner's.
**
**  Aruments
**      data    buffer      The data received from partner
**
**  Returns
**      <nothing>
**
*/

var data = argument0;
var net_id = buffer_read(data, buffer_string);
var xPos = buffer_read(data, buffer_f32);
var yPos = buffer_read(data, buffer_f32);

with( syncMap[? net_id] )
{
    x = xPos;
    y = yPos;    
}

