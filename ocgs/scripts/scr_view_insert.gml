///scr_view_insert(view, x, y, card)
/*
**  Description
**      inserts the specified card into the correct location based on specified coordinates
**
**  Arguments
**      x       real        the x coordinate of where the card is being inserted
**      y       real        the y coordinate of where the card is being inserted
**      card    obj_card    the card being inserted
**
**  Returns
**      <nothing>
**
*/

with(argument0)
{
    var xCoord = argument1;
    var yCoord = argument2;
    var card = argument3;

    var first_bottom_edge = y + margin + item_height;
    var left_center = x + margin + item_width/2;
    
    var row = -1;
    var column = -1;
    var pos, idx;
    
    var count = 0;
    while(yCoord > first_bottom_edge+count*(item_height+padding) )
    {
        count++;
    }
    row = count;
    
    count = 0;
    while(xCoord > left_center + count*(item_width+padding) )
    {
        count++;
    }
    column = count;
    
    if( row = num_rows || ( row = num_rows - 1 && column = per_row ) )
    {   //  Was placed outside of the visible grid
        //  consider it placed at the first location on the next page
        idx = (curr_page + 1) * per_page;
    }
    else
    {   //  Use row and column to determine position on page,
        //  and use that to find the overall index for the view
        pos = (per_row * row) + column;
        idx = (curr_page * per_page) + pos;
    }
    
    //  If all the cards shown in the view have been flipped
    //  When we insert the card, flip it too.
    if(flip_all)
    {
        scr_flip_card(card);
    }
    
    
    //  Determine where in the deck to place the card
    var map = scr_map_from_card(card);    
    if(idx < num)
    {   //  Placed in top section
        ds_list_insert(deck.list, idx, map);
        ++num;
    }
    else if(idx == num)
    {   //  It on the boundary between the top and bottom sections
        
        if(xCoord <= left_center + column*(item_width+padding) - item_width/2)        
        {   //  Placed a bit further left; put in the top.
            ds_list_insert(deck.list, idx, map);
            ++num;
        }
        else
        {   //  Placed a bit further right; put in the bottom.
            var size = ds_list_size(deck.list);
            idx = min(size - reverse + idx - num, size);
            
            ds_list_insert(deck.list, idx, map)
            ++reverse;
        }
    }
    else
    { // Place after the end
        var size = ds_list_size(deck.list);
        idx = min(size - reverse + idx - num, size);
        
        ds_list_insert(deck.list, idx, map);
        reverse++;
        
    }
    
    sync_deck_insert(deck, card, idx);
    with(card) instance_destroy();        
    scr_view_update(id);
}
