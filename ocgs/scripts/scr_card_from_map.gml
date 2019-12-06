/// scr_activate_card(cardmap)
/*
**  Description
**      Creates a card based on a map.
**      DOES NOT DESTROY THE MAP.
**
**  Arguments
**      cardmap     ds_map      The map to use to create the card.
**
**  Returns
**      The ID of the card created.
**
*/

var map = argument0;

with( instance_create(x, y, obj_card) ) {

    // Set up all of the card's data using the data from the map.
    sprite_index = map[? "sprite"];
    
    net_id = map[? "net_id"];
    
    width = map[? "width"];
    height = map[? "height"];
    flipped = map[? "flipped"];
    
    scale_x = map[? "scale_x"];
    scale_y = map[? "scale_y"];
    
    offset_x = map[? "offset_x"];
    offset_y = map[? "offset_y"];
    
    sprite_net_id = map[? "sprite_net_id"];
    
    image_xscale = global.scale * scale_x;
    image_yscale = global.scale * scale_y;
    sprite_set_offset(sprite_index, offset_x, offset_y );     
    
    if( flipped )
    {
        image_index = 1;
    }
    else
    {
        image_index = 0;
    }
    
    return id;
}
