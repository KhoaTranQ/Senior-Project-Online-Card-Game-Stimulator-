///scr_create_test_card()
/*
**  Description
**      Creates a predefined card for testing purposes.
**
**  Arguments
**      <none>
**
**  Returns
**      <nothing>
**
*/

var syncMap = global.net_object.syncMap;

with instance_create(mouse_x, mouse_y, obj_card) {

    //spacing
    show_debug_message("");
    show_debug_message("");
    show_debug_message("");
    
    var sprite = sprite_add("bluffs.jpg", 0,0,0,0,0);
    var tmp = sprite_add("back.jpg", 0,0,0,0,0);
    sprite_merge(sprite, tmp);
    sprite_delete(tmp);   
    sprite_index = sprite; 
    
    sprite_net_id = sync_sprite(sprite, "bluffs.jpg", "back.jpg");    
    
    //var net_id = sync_sprite("bluffs.jpg");
    show_debug_message("In con_IM MP, net_id is: " + string(net_id) );
    
    
    var img_width = sprite_get_width(sprite);
    var img_height = sprite_get_height(sprite);
    
    var norm_width = 63;
    var norm_height = 88;
    
    height = norm_height;
    width = norm_width;
    
    offset_x = img_width / 2;
    offset_y = img_height / 2;
    scale_x = norm_width / img_width;
    scale_y = norm_height / img_height;
    
    flipped = false;    
    scale = 2; // default value. Can be changed.

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
    
    
    sync(id);
    ds_list_add(global.freeCards, id);
}

scr_update_depths();

