///scr_draw_from_deck(deck)
/*
**
**  Desription
**      Draws a card from a deck by creating a card based on the first map,
**      selecting it, and destroying the map.
**
**  Arguments
**      deck    instance    The deck to draw from.
**
**  Returns
**      obj_card    The card that is drawn.
**
*/

with(argument0) {
    
    var cardmap = ds_list_find_value(list, 0);     // get top card
    
    //  Convert the map to a real card.
    var card = scr_card_from_map(cardmap);    
    
    card.image_angle = image_angle;
    
    // Now that the card exists on its own, add it to the freeCards depth manager.
    ds_list_add(global.freeCards, card);
    
    
    //Free cardmap from memory, and remove the card from the deck.
    ds_map_destroy(cardmap);
    ds_list_delete(list, 0);
    
    //sync_draw_deck(argument0);
    sync_deck_draw(argument0, card);
    
    // Update the view/search zone, if there is one
    scr_view_update(view, true, -1);
    
    // If the deck is empty, delete it and its gizmo.
    if( ds_list_empty(list) ) {
        with(gizmo)
            instance_destroy();
        instance_destroy();
    }
}

return card;
// Attatch the card to the cursor.
//scr_select_card(card);
