///net_create_card(data)
/*
**  Description
**      Creates a new card based on information recieved from partner.
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
*/

var buff = argument0;

var net_id = buffer_read(buff, buffer_string);
var xPos = buffer_read(buff, buffer_f32);
var yPos = buffer_read(buff, buffer_f32);
var mapString = buffer_read(buff, buffer_string);
var map = ds_map_create();
ds_map_read(map, mapString);

with( scr_card_from_map(map) ) {
    x = room_width - xPos;
    y = room_height - yPos;
    id.net_id = net_id;
    ds_map_add(other.syncMap, net_id, id);
    ds_list_add(global.freeCards, id);
}

scr_update_depths();
ds_map_destroy(map);
