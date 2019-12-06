///scr_select(clicked)
/*
**  Description
**      Selects the specified clicked or deck
**
**  Arguments
**      clicked   mixed   Can be a obj_card, or obj_deck
**
**  Returns
**      <nothing>
**
*/

///TODO: Manage special zones

with(global.input_object)
{
    var clicked = argument0;
    //var type = clicked.object_index;
    
    switch(clicked.object_index)
    {
        case obj_card:
       
            selected = clicked;            
            break;
            
        case obj_gizmo:
        
            clicked = clicked.deck;
            
        case obj_deck:
       
            selected = clicked;
           break;
            
        case obj_view:
            selected = clicked;
           
            break;
    }
    
    // Check if the card is in a special zone (hand, view/search)
    var pos = ds_list_find_index(global.handCards, clicked);
    var view_ = scr_view_find(clicked);
    if( pos >= 0)
    { // Card was in the hand. Remove it from the hand, add it to free cards, and correct its scale.
    
        with(clicked)
        {   
            image_xscale = global.scale * scale_x;
            image_yscale = global.scale * scale_y;
            sprite_set_offset(sprite_index, offset_x, offset_y );
        }
        
        ds_list_delete(global.handCards, pos);
        ds_list_add(global.freeCards, clicked);
        debug("Card from hand selected. last_zone before reset: " + string(clicked.last_zone));
        clicked.last_zone = zone.hand;
        debug("last_zone after reset: " + string(clicked.last_zone));
    }
    else if( view_ != noone)
    { // Card was in view panel. Remove it.
        
        clicked.last_zone = zone.view;
        scr_view_remove(view_, clicked);
    }
    else
    {
        // Update all card's last zone
        if( ds_list_find_index(multi, clicked) >= 0 )
        {
            for(var i = 0; i < ds_list_size(multi); ++i)
            {
                multi[| i].last_zone = zone.main;
            }
        }
        else
        {
            clicked.last_zone = zone.main;
        }
    }
    
    //Update the card's depth.
    if( ds_list_find_index(multi, clicked) >= 0 )
    {
        for(var i = 0; i < ds_list_size(multi); ++i)
        {
            multi[| i].depth = -5
        }
    }
    else if(selected.object_index != obj_view)
    {
     
        clicked.depth = -5;
    }
}

