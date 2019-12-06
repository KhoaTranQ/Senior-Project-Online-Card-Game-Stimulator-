///scr_view_move(view)
/*
**  Description
**      Updates the positions of the cards in the view
**
**  Arguments
**      view    obj_view    The view being updated
**
**  Returns
**      <nothing>
**
*/

with(argument0)
{
    x1 = x - nav;
    y1 = y - nav;
    x2 = x + width + nav;
    y2 = y + height + nav;
    
    var size = ds_list_size(list);
    var card, row, column;
    
    for(i = 0; i < size; i++)
    {
        card = list[| i];
        
        row = i div per_row;
        column = i mod per_row;
        
        card.x = x + margin + item_width/2 + column*(item_width+padding);
        card.y = y + margin + item_height/2 + row*(item_height+padding);
    }
}
