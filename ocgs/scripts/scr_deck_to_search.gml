///scr_draw_from_deck(deck)
//argument0: Deck to draw from (inst of obj_deck)

with(argument0) {
    var cardmap = ds_list_find_value(list, 0);     // get top card
    
    //instance_activate_object(card);     // Make the card exist again
    var card = scr_activate_card(cardmap);
    
    // Now that the card exists on its own, add it to the freeCards depth manager.
    ds_list_add(global.searchCards, card);
    
    scr_select_card(card);
    
   
    
   
    }

