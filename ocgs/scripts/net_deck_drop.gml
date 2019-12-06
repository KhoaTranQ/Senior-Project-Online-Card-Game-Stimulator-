///net_deck_drop(data)
/*
**  Description
**      Drops a card onto a deck based on info received from partner.
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
*/

var data = argument0;

var deck_net_id = buffer_read(data, buffer_string);
var card_net_id = buffer_read(data, buffer_string);

var local_deck = syncMap[? deck_net_id];
var local_card = syncMap[? card_net_id];

scr_drop_on_deck(local_deck, local_card);

//scr_drop_on_deck will destroy the local card, so remove it from the map.
ds_map_delete(syncMap, card_net_id);
