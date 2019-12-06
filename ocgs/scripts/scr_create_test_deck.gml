///scr_create_test_deck()
/*
**  Description
**      Creates a deck of random preset cards for testing purposes
**
**  Arguments
**      <none>
**
**  Returns
**      <nothing>
*/

var deck = instance_create(mouse_x, mouse_y, obj_deck);
//var map = ds_map_c
repeat(10)
{
    var map = ds_map_create();
    // 0 is bluffs, 1 is liliana
    switch choose(0, 1)
    {
        case 0:
            var front_path = "bluffs.jpg";
            var back_path = "back.jpg";            
            break;
            
        case 1:
            var front_path = "liliana.jpg";
            var back_path = "zombie.jpg";    
            break;
            
        default:
            show_message_async("con_inputManager Middle Pressed error: Shouldn't this be impossible?");
            break;
    }    
    
    var sprite = sprite_add(front_path, 0,0,0,0,0);
    var tmp = sprite_add(back_path, 0,0,0,0,0);
    sprite_merge(sprite, tmp);
    sprite_delete(tmp);   
    
    sprite_net_id = sync_sprite(sprite, front_path, back_path);    
    
    map[? "sprite"] = sprite;
    map[? "sprite_net_id"] = sprite_net_id;
    var img_width = sprite_get_width(sprite);
    var img_height = sprite_get_height(sprite);
    
    var norm_width = 63;
    var norm_height = 88;
    
    map[? "height"] = norm_height;
    map[? "width"] = norm_width;
    
    map[? "offset_x"] = img_width / 2;
    map[? "offset_y"] = img_height / 2;
    map[? "scale_x"] = norm_width / img_width;
    map[? "scale_y"] = norm_height / img_height;
    
    map[? "flipped"] = false;
    
    map[? "net_id"] = net_hash();
    
    ds_list_add(deck.list, map);
    
}

sync(deck);
