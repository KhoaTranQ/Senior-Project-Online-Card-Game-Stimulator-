///net_add_sprite(data)
/*
**  Description
**      Adds a sprite to the game based on resources given by partner
**      And associates that sprite with a unique network ID shared with partner
**
**  Arguments
**      data  buffer  The buffer that contains the synchronization data
**
**  Returns
**      <nothing>
**
*/

var data = argument0;
var net_id = buffer_read(data, buffer_string);
var front_name = buffer_read(data, buffer_string);
var back_name = buffer_read(data, buffer_string); 

var sprite = sprite_add("received\tmp\" + front_name, 0,0,0,0,0);
var tmp = sprite_add("received\tmp\" + back_name, 0,0,0,0,0);
sprite_merge(sprite, tmp);
sprite_delete(tmp);

ds_map_add(global.net_object.syncMap, net_id, sprite);      


