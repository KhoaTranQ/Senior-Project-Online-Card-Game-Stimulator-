///net_update_cardPos(buffer)
/*
**  Description
**      Updates local card's position to match partner's.
**
**  Aruments
**      data    buffer      The data received from partner
**
**  Returns
**      <nothing>
**
*/

var buff = argument0;
var net_id = buffer_read(buff, buffer_string);
var xPos = buffer_read(buff, buffer_f32);
var yPos = buffer_read(buff, buffer_f32);

with( syncMap[? net_id] ) {
    x = xPos;
    y = yPos;
    
    scr_moveto_end(global.freeCards, id)
    scr_update_depths();
}

