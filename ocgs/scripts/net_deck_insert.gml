///net_deck_insert(data)
/*
**  Description
**      Inserts a card into a deck at a specific position
**
*/

var data = argument0;

var deck_id = buffer_read(data, buffer_string);
var card_id = buffer_read(data, buffer_string);
var pos = buffer_read(data, buffer_f32);

var local_deck = syncMap[? deck_id];
var local_card = syncMap[? card_id];

var map = scr_map_from_card(local_card);

ds_list_insert(local_deck.list, pos, map);

ds_map_delete(syncMap, card_id);


with(global.input_object)
{
    scr_deselect_multi();
}

with(local_card)
{
    instance_destroy();
}
