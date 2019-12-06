/// scr_card_to_deck(card)
/*
**  Description
**      Converts a single free card into a single-card deck.
**
**  Arguments
**      card    obj_card    The card to convert into a deck.
**
**  Returns
**      <nothing>
**
*/

var card = argument0

var deck = instance_create(card.x, card.y, obj_deck);
var map = scr_map_from_card(card);

ds_list_add(deck.list, map)

deck.image_angle = card.image_angle;

with(card)
{
    instance_destroy();
}

return deck.id
