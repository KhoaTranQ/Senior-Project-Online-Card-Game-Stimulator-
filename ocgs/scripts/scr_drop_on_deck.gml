/// scr_drop_on_deck(deck, card)
/*
**
**  Description
**      Gets a cardmap from the card, adds that to the deck, and deletes the card.
**
**  Arguments
**      deck    obj_deck    The deck to drop on
**      card    obj_card    The card being dropped
**
**  Returns
**      <nothing>
**
*/

var deck = argument0;
var card = argument1;

//debug("Dropping card with network ID " + string(card.net_id) + "on deck with network ID " + deck.net_id);



// create a map from the card.
var cardmap = scr_map_from_card(card);

// Delete the card.
with(card)
    instance_destroy();
    

// Put the cardmap in the front.
ds_list_insert(deck.list, 0, cardmap);

//update associated view, if there is one.
scr_view_update(deck.view, true, 1);

