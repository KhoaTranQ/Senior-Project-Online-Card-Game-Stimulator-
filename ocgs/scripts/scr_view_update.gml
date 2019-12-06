///scr_view_update(view, [update_type], [resize])
/*
**  Description
**      Signals view to update its layout. Can be full (default), or for card coordinates only.
**
**  Arguments
**      view        obj_view    The view to update
**      [full]      boolean     [Optional] whether or not to update everything, or just card positions.
**      [resize]    real        [Optional] The amount to resize the view. Positive adds, negative removes. default 0. 
**
**  Returns
**      <nothing>
**
*/

with(argument[0])
{
    //By default, do a full update, and don't modify the number of top cards to display
    var do_full = true;
    var resize = 0;
    
    if(argument_count > 1)
    {
        do_full = argument[1];
    }
    
    if(argument_count > 2)
    {
        resize = argument[2]
    }
    
    if(do_full)
    {
        // reset num, num_pages and clear out the list
        
        if( num > 0 || resize >= 0)
        {
            num += resize
        }
        else
        {
            if(reverse > 0)
            {
                reverse += resize
            }
        }
        
        num_pages = ceil((num+reverse) / per_page);        
        for(i = 0; i < ds_list_size(list); i++)
        {
            with(list[| i])
            {
                instance_destroy();
            }
        }        
        ds_list_clear(list);
        
        
        // Repopulate the list, first with cards from the front
        var card = noone;
        var deck_size = ds_list_size(deck.list);
        var last = min( (curr_page + 1) * per_page, num + reverse);
        
        for(i = curr_page * per_page; i < last; i++)
        {
            if(i < num)
            {
                card = scr_card_from_map(deck.list[| i]);
            }
            else
            {
                card = scr_card_from_map(deck.list[| deck_size - reverse + i - num]);
            }
                        
            if(flip_all)
            {
                scr_flip_card(card);
            }
            
            
            ds_list_add(list, card);
        }
    }
    
    
    x1 = x - nav;
    y1 = y - nav;
    x2 = x + width + nav;
    y2 = y + height + nav;
    
    var card, row, column;
    
    for(i = 0; i < ds_list_size(list); i++)
    {
        card = list[| i];   
            
        row = i div per_row;
        column = i mod per_row;
        
        card.x = x + margin + item_width/2 + column*(item_width+padding);
        card.y = y + margin + item_height/2 + row*(item_height+padding);
    }
    
    scr_view_depths();
}

