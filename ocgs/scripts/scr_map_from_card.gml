///scr_map_from_card(card)
/*
**  Description
**      Creates a map that represents the card.
**      DOES NOT DESTROY THE CARD.
**      Remember to delete the map when you're done with it!
**
**  Arguments
**      card    obj_card    The card to use for creating the map.
**
**  Returns
**      The map created from the card.
**
*/

var map = ds_map_create();

with(argument0)
{    

    // Populate the map's data using the card's instance variables.
    map[? "sprite"] = sprite_index;
    map[? "net_id"] = net_id;
    map[? "sprite_net_id"] = sprite_net_id;
    
    map[? "width"] = width;
    map[? "height"] = height;
    
    map[? "offset_x"] = offset_x
    map[? "offset_y"] = offset_y
    
    map[? "scale_x"] = scale_x;
    map[? "scale_y"] = scale_y;
    
    map[? "flipped"] = flipped;
}

return map;
