///net_create_deck(data)
/*
**  Description
**      Adds a deck to the game based on information given by partner
**      And associates that deck with a unique network ID shared with partner
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
var xPos = buffer_read(data, buffer_f32);
var yPos = buffer_read(data, buffer_f32);
var list_string = buffer_read(data, buffer_string);

var deck = instance_create(room_width - xPos, room_height - yPos, obj_deck);
with(deck)
{
    image_angle += 180;
}

deck.net_id = net_id;
ds_map_add(syncMap, net_id, deck);

var tmp_list = ds_list_create();
ds_list_read(tmp_list, list_string);
var size = ds_list_size(tmp_list);

var sprite_local_id;
for(var i = 0; i < size; i++)
{
    //debug("networking addDeck tmp_list population");
    var map = ds_map_create();
    ds_map_read(map, tmp_list[| i]);
    
    // Replace the old "sprite" field with the sprite_id associated with sprite_net_id
    var sprite_net_id = map[? "sprite_net_id"];
    var sprite_local_id = syncMap[? sprite_net_id];
    map[? "sprite"] = sprite_local_id;
    
    ds_list_add(deck.list, map);
}

ds_list_destroy(tmp_list);

var top_card = deck.list[| 0];
//var top_spr_net_id = top_card[? "sprite_net_id"];
//debug("Top card's map is: ##" + json_encode(top_card));
//debug("Top sprite's network ID is: " + top_spr_net_id);
deck.sprite_index = top_card[? "sprite"];//syncMap[? top_spr_net_id];
                                
