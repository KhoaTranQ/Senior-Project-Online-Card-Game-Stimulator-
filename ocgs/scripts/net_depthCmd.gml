///net_depthCmd(data)
/*
**  Description
**      Update specified card's depth based on a given command
**      0: Bring to front
**      1: Send to back
**
**  Arguments
**      data    buffer      Buffer containing information for operation
**
**  Returns
**      <nothing>
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var command = buffer_read(data, buffer_u8);

var local_inst = syncMap[? net_id];

switch(command)
{
    //Bring to front
    case 0:
        scr_moveto_end(global.freeCards, local_inst);
        break;
        
    //Send to back
    case 1:
        scr_moveto_start(global.freeCards, local_inst);
        break;
}
scr_update_depths();
