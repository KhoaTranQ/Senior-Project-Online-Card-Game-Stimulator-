//argument0: Deck to draw from (inst of obj_deck)

with(argument0) {
    var card = ds_list_find_value(list, 0);
    
    instance_activate_object(card);
    
    //sprite_set_offset(card.sprite_index, mouse_x - x, mouse_y - y);
    global.selected = card;
    global.selectedXOffset = mouse_x - x;
    global.selectedYOffset = mouse_y - y;
    
    // Can't do this in the same frame it's been activated?
    //global.selected.depth = -1;
    
    // Stop tracking this card.
    ds_list_delete(list, 0);
    
    if( ds_list_empty(list) ) {
        instance_destroy();
    }
}
