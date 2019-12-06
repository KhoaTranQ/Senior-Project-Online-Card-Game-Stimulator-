///net_draw_deck(data)
/*
**  Description
**      "Draw"s from a deck specified by partner.
**
**  Arguments
**      data    buffer      The buffer that contains the data used for synchronization
**
**  Returns
**      <nothing>
**
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var deck = syncMap[? net_id];

// Create the top card
var topmap = deck.list[| 0];
var topcard = scr_card_from_map(topmap);
ds_list_add(global.freeCards, topcard);

//Make it a bit more obvious a deck has been drawn from.
topcard.x = deck.x + 10;
topcard.y = deck.y + 10;
topcard.image_angle = deck.image_angle;
topcard.depth = -0.01

//syncMap[? topcard.net_id] = topcard.id;

//associate new card's ID with 
ds_map_add(syncMap, topcard.net_id, topcard.id);

ds_list_delete(deck.list, 0);

scr_view_update(deck.view, true, -1);
