/// net_card_create(x, y, cardmap)

/*
**
*/

var xPos = argument0;
var yPos = argument1;
var map = argument2;

//var syncMap = global.net_object.syncMap

with( instance_create(xPos, yPos, obj_card) ) {
    
    // Create a unique ID for this instance
    // and associate it's local ID with its network ID.
    net_ID = net_hash();
    
    ds_map_add(global.net_object.syncMap, net_ID, id);  

    front = map[? "front"];  
    back = map[? "back"];
    scale = map[? "scale"];
    width = map[? "width"];
    height = map[? "height"];
    flipped = map[? "flipped"];
    
    front_scale_x = map[? "front_scale_x"];
    front_scale_y = map[? "front_scale_y"];
    back_scale_x = map[? "back_scale_x"];
    back_scale_y = map[? "back_scale_y"];
    
    front_offset_x = map[? "front_offset_x"];
    front_offset_y = map[? "front_offset_y"];
    back_offset_x = map[? "back_offset_x"];
    back_offset_y = map[? "back_offset_y"];
    
    if( flipped == false) {    
        sprite_index = front;
        image_xscale = scale * front_scale_x;
        image_yscale = scale * front_scale_y;
        sprite_set_offset(sprite_index, front_offset_x, front_offset_y );        
    }
    else {
        sprite_index = back;
        image_xscale = scale * back_scale_x;
        image_yscale = scale * back_scale_y;
        sprite_set_offset(sprite_index, back_offset_x, back_offset_y );            
    }
    
    net_sync_new_card(net_ID, x, y, map);
    
    return net_ID;    
}


