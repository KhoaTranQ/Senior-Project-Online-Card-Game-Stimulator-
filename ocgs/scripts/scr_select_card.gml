/// scr_select_card(card)

/*
**  Description
**      Selects the specified card. Maxes its depth.
**
**  Arguments
**      card    obj_card    The card to select.
**
**  Returns
**      <nothing>
**
*/

// Run this from the context of con_inputManager
with(global.input_object)
{
    var card = argument0;
    
    selected = card;
    selectedXOffset = mouse_x - card.x;
    selectedYOffset = mouse_y - card.y;
    
    card.depth = -5;
    
    var pos = ds_list_find_index(global.handCards, card);
    if( pos >= 0) { // Card was in the hand. Remove it from the hand, add it to free cards, and correct its scale.
    
        with(card)
        {
            image_xscale = global.scale * scale_x;
            image_yscale = global.scale * scale_y;
            sprite_set_offset(sprite_index, offset_x, offset_y );
        }
    
        ds_list_delete(global.handCards, pos);
        ds_list_add(global.freeCards, card);
        
        sync_hand_remove(card)
    }
}
