///net_card_to_deck(data)
/*
**  Description
**      Converts a card into a deck based on information received from partner
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
*/

var data = argument0;

var card_net_id = buffer_read(data, buffer_string);
var deck_net_id = buffer_read(data, buffer_string);

var local_card = syncMap[? card_net_id];

//If we happen to have that card selected, deselect it first.
with( global.input_object)
{
    if(selected == local_card)
    {
        selected = noone;
    }    
}

// currently not checking to see if partner put card in hand, but I think it's safe.

var cardMap = scr_map_from_card(local_card);

var deck = instance_create(local_card.x, local_card.y, obj_deck);

//Don't destroy the map, because it's a part of the deck.
ds_list_add(deck.list, cardMap);
deck.net_id = deck_net_id;
deck.image_angle = local_card.image_angle;

with(local_card)
{
    instance_destroy();
}

ds_map_delete(syncMap, card_net_id);
ds_map_add(syncMap, deck.net_id, deck);


