///net_rotate(data)
/*
**  Description
**      Rotates a card based on information from partner
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var amt = buffer_read(data, buffer_f32);

var local_inst = syncMap[? net_id];

scr_rotate(local_inst, amt);

/*
with(local_inst)
{
    image_angle += amt
    if(image_angle >= 360 || image_angle < 0)
        image_angle = image_angle mod 360;
}
                
